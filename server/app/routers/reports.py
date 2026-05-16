from fastapi import APIRouter, HTTPException, Query
from ..models.waste_report import WasteReportCreate
from ..services.firebase_service import FirebaseService

router = APIRouter()
COLLECTION = "waste_reports"


@router.get("/")
async def list_reports(
    from_date: str | None = Query(None),
    to_date: str | None = Query(None),
):
  return await FirebaseService.list_documents(COLLECTION, from_date, to_date)


@router.post("/")
async def create_report(payload: WasteReportCreate):
  doc_id = await FirebaseService.create_document(
      COLLECTION,
      payload.model_dump(),
  )
  return {"id": doc_id}


@router.get("/{report_id}")
async def get_report(report_id: str):
  doc = await FirebaseService.get_document(COLLECTION, report_id)
  if not doc:
    raise HTTPException(status_code=404, detail="Report not found")
  return doc


@router.patch("/{report_id}")
async def update_report(report_id: str, data: dict):
  await FirebaseService.update_document(COLLECTION, report_id, data)
  return {"status": "updated"}


@router.delete("/{report_id}")
async def delete_report(report_id: str):
  await FirebaseService.delete_document(COLLECTION, report_id)
  return {"status": "deleted"}
