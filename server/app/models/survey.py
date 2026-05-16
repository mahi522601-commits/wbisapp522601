from datetime import datetime, timezone
from enum import Enum
from pydantic import BaseModel, ConfigDict, Field


class WasteStatus(str, Enum):
  proper = "proper"
  minorMixing = "minorMixing"
  mixedWaste = "mixedWaste"
  hazardous = "hazardous"


SCORE_IMPACT = {
    WasteStatus.proper: 10,
    WasteStatus.minorMixing: 5,
    WasteStatus.mixedWaste: -5,
    WasteStatus.hazardous: -15,
}

COLOR_CODE = {
    WasteStatus.proper: "GREEN",
    WasteStatus.minorMixing: "YELLOW",
    WasteStatus.mixedWaste: "RED",
    WasteStatus.hazardous: "BLACK",
}


class SurveyCreate(BaseModel):
  model_config = ConfigDict(use_enum_values=True)

  userId: str
  householdId: str
  wardName: str
  city: str
  status: WasteStatus
  latitude: float
  longitude: float
  photoUrl: str | None = None
  workerNotes: str | None = None
  behaviourScore: int | None = None
  isValidated: bool = False
  validatedBy: str | None = None
  createdAt: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))
  validatedAt: datetime | None = None
  metadata: dict = Field(default_factory=dict)

  def to_firestore(self) -> dict:
    status = WasteStatus(self.status)
    data = self.model_dump()
    data["status"] = status.value
    data["colorCode"] = COLOR_CODE[status]
    data["behaviourScore"] = self.behaviourScore or SCORE_IMPACT[status]
    return data


class SurveyUpdate(BaseModel):
  model_config = ConfigDict(use_enum_values=True)

  householdId: str | None = None
  wardName: str | None = None
  city: str | None = None
  status: WasteStatus | None = None
  latitude: float | None = None
  longitude: float | None = None
  photoUrl: str | None = None
  workerNotes: str | None = None
  behaviourScore: int | None = None
  isValidated: bool | None = None
  validatedBy: str | None = None
  validatedAt: datetime | None = None
  metadata: dict | None = None
