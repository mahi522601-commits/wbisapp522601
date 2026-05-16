from fastapi import APIRouter
from ..services.firebase_service import FirebaseService

router = APIRouter()


@router.get("/stats")
async def stats():
  surveys = await FirebaseService.list_documents("surveys", limit=500)
  reports = await FirebaseService.list_documents("waste_reports", limit=500)
  users = await FirebaseService.list_documents("users", limit=500)
  workers = await FirebaseService.list_documents("workers", limit=500)
  return {
      "users": len(users),
      "workers": len(workers),
      "surveys": len(surveys),
      "reports": len(reports),
      "proper": len([s for s in surveys if s.get("status") == "proper"]),
      "hazardous": len([s for s in surveys if s.get("status") == "hazardous"]),
  }


@router.get("/analytics")
async def analytics():
  return await FirebaseService.list_documents("analytics", limit=90)
