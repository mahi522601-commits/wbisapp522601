from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .config import settings
from .routers import admin, auth, export, reports, scores, surveys, workers
from .utils.firebase_admin import initialize_firebase

app = FastAPI(
    title="WBIS API",
    description="Waste Behaviour Intelligence System Backend",
    version="2.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=list(settings.cors_origins) or ["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

initialize_firebase()

app.include_router(auth.router, prefix="/api/auth", tags=["Auth"])
app.include_router(surveys.router, prefix="/api/surveys", tags=["Surveys"])
app.include_router(reports.router, prefix="/api/reports", tags=["Reports"])
app.include_router(scores.router, prefix="/api/scores", tags=["Scores"])
app.include_router(admin.router, prefix="/api/admin", tags=["Admin"])
app.include_router(workers.router, prefix="/api/workers", tags=["Workers"])
app.include_router(export.router, prefix="/api/export", tags=["Export"])


@app.get("/health")
def health():
  return {"status": "ok", "system": "WBIS v2.0"}
