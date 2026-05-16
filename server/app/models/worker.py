from datetime import datetime, timezone
from pydantic import BaseModel, Field


class WorkerCreate(BaseModel):
  userId: str
  name: str
  wardAssigned: str
  routeCompleted: int = 0
  missedHouseholds: int = 0
  reportingAccuracy: float = 0
  lastActive: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))


class WorkerUpdate(BaseModel):
  name: str | None = None
  wardAssigned: str | None = None
  routeCompleted: int | None = None
  missedHouseholds: int | None = None
  reportingAccuracy: float | None = None
  lastActive: datetime | None = None
