from datetime import datetime, timezone
from pydantic import BaseModel, Field


class BehaviourScore(BaseModel):
  userId: str
  totalScore: int = 0
  surveyCount: int = 0
  ecoPoints: int = 0
  lastUpdated: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))
