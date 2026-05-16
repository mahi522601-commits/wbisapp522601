from datetime import datetime, timezone
from enum import Enum
from pydantic import BaseModel, ConfigDict, Field


class WasteReportStatus(str, Enum):
  submitted = "submitted"
  underReview = "underReview"
  resolved = "resolved"
  rejected = "rejected"


class WasteCategory(str, Enum):
  dry = "dry"
  wet = "wet"
  sanitary = "sanitary"
  hazardous = "hazardous"
  mixed = "mixed"
  unknown = "unknown"


class WasteReportCreate(BaseModel):
  model_config = ConfigDict(use_enum_values=True)

  userId: str
  category: WasteCategory = WasteCategory.unknown
  status: WasteReportStatus = WasteReportStatus.submitted
  description: str
  city: str
  wardName: str
  latitude: float
  longitude: float
  photoUrl: str | None = None
  createdAt: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))
  resolvedAt: datetime | None = None
