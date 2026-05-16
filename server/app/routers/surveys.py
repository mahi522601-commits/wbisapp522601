from datetime import datetime, timezone
from fastapi import APIRouter, HTTPException, Query
from ..models.survey import COLOR_CODE, SCORE_IMPACT, SurveyCreate, SurveyUpdate, WasteStatus
from ..services.firebase_service import FirebaseService
from ..services.score_engine import ScoreEngine

router = APIRouter()
COLLECTION = "surveys"


@router.get("/")
async def list_surveys(
    from_date: str | None = Query(None),
    to_date: str | None = Query(None),
):
  return await FirebaseService.list_documents(COLLECTION, from_date, to_date)


@router.post("/")
async def create_survey(payload: SurveyCreate):
  data = payload.to_firestore()
  doc_id = await FirebaseService.create_document(COLLECTION, data)
  await ScoreEngine.apply_survey_score(payload.userId, payload.status)
  return {"id": doc_id}


@router.get("/{survey_id}")
async def get_survey(survey_id: str):
  doc = await FirebaseService.get_document(COLLECTION, survey_id)
  if not doc:
    raise HTTPException(status_code=404, detail="Survey not found")
  return doc


@router.patch("/{survey_id}")
async def update_survey(survey_id: str, payload: SurveyUpdate):
  data = payload.model_dump(exclude_unset=True)
  if payload.status:
    status = WasteStatus(payload.status)
    data["colorCode"] = COLOR_CODE[status]
    data["behaviourScore"] = payload.behaviourScore or SCORE_IMPACT[status]
  await FirebaseService.update_document(COLLECTION, survey_id, data)
  return {"status": "updated"}


@router.post("/{survey_id}/validate")
async def validate_survey(
    survey_id: str,
    worker_id: str,
    status: WasteStatus,
):
  await FirebaseService.update_document(COLLECTION, survey_id, {
      "isValidated": True,
      "validatedBy": worker_id,
      "status": status.value,
      "colorCode": COLOR_CODE[status],
      "behaviourScore": SCORE_IMPACT[status],
      "validatedAt": datetime.now(timezone.utc),
  })
  return {"status": "validated"}


@router.delete("/{survey_id}")
async def delete_survey(survey_id: str):
  await FirebaseService.delete_document(COLLECTION, survey_id)
  return {"status": "deleted"}
