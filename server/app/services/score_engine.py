from datetime import datetime, timezone
from firebase_admin import firestore
from ..models.survey import SCORE_IMPACT, WasteStatus
from ..utils.firebase_admin import get_firestore_client


class ScoreEngine:
  @staticmethod
  def score_for_status(status: str | WasteStatus) -> int:
    return SCORE_IMPACT[WasteStatus(status)]

  @classmethod
  async def apply_survey_score(cls, user_id: str, status: str | WasteStatus) -> None:
    score = cls.score_for_status(status)
    db = get_firestore_client()
    ref = db.collection("behaviour_scores").document(user_id)

    @firestore.transactional
    def update(transaction):
      snap = ref.get(transaction=transaction)
      if snap.exists:
        data = snap.to_dict() or {}
        current = int(data.get("totalScore", 0))
        eco_points = int(data.get("ecoPoints", 0))
        transaction.update(ref, {
            "totalScore": current + score,
            "ecoPoints": eco_points + max(score, 0),
            "surveyCount": firestore.Increment(1),
            "lastUpdated": datetime.now(timezone.utc),
        })
      else:
        transaction.set(ref, {
            "userId": user_id,
            "totalScore": score,
            "surveyCount": 1,
            "ecoPoints": max(score, 0),
            "lastUpdated": datetime.now(timezone.utc),
        })

    update(db.transaction())
