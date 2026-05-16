from fastapi import APIRouter, HTTPException
from ..models.worker import WorkerCreate, WorkerUpdate
from ..services.firebase_service import FirebaseService

router = APIRouter()
COLLECTION = "workers"


@router.get("/")
async def list_workers():
  return await FirebaseService.list_documents(COLLECTION)


@router.post("/")
async def create_worker(payload: WorkerCreate):
  doc_id = await FirebaseService.create_document(COLLECTION, payload.model_dump())
  return {"id": doc_id}


@router.get("/{worker_id}")
async def get_worker(worker_id: str):
  doc = await FirebaseService.get_document(COLLECTION, worker_id)
  if not doc:
    raise HTTPException(status_code=404, detail="Worker not found")
  return doc


@router.patch("/{worker_id}")
async def update_worker(worker_id: str, payload: WorkerUpdate):
  await FirebaseService.update_document(
      COLLECTION,
      worker_id,
      payload.model_dump(exclude_unset=True),
  )
  return {"status": "updated"}


@router.delete("/{worker_id}")
async def delete_worker(worker_id: str):
  await FirebaseService.delete_document(COLLECTION, worker_id)
  return {"status": "deleted"}
