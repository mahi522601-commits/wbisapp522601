from fastapi import APIRouter, HTTPException
from ..models.score import BehaviourScore
from ..services.firebase_service import FirebaseService

router = APIRouter()
COLLECTION = "behaviour_scores"


@router.get("/")
async def leaderboard(limit: int = 50):
  return await FirebaseService.list_documents(COLLECTION, limit=limit)


@router.get("/{user_id}")
async def get_score(user_id: str):
  doc = await FirebaseService.get_document(COLLECTION, user_id)
  if not doc:
    raise HTTPException(status_code=404, detail="Score not found")
  return doc


@router.put("/{user_id}")
async def set_score(user_id: str, payload: BehaviourScore):
  await FirebaseService.create_document(
      COLLECTION,
      payload.model_dump(),
      doc_id=user_id,
  )
  return {"status": "saved"}
