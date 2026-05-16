from datetime import datetime, timezone
from enum import Enum
from pydantic import BaseModel, ConfigDict, Field


class UserRole(str, Enum):
  citizen = "citizen"
  worker = "worker"
  admin = "admin"


class UserCreate(BaseModel):
  model_config = ConfigDict(use_enum_values=True)

  uid: str
  email: str
  displayName: str
  phone: str = ""
  role: UserRole = UserRole.citizen
  wardName: str = ""
  city: str = ""
  householdId: str = ""
  photoUrl: str | None = None
  createdAt: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))


class UserUpdate(BaseModel):
  model_config = ConfigDict(use_enum_values=True)

  displayName: str | None = None
  phone: str | None = None
  role: UserRole | None = None
  wardName: str | None = None
  city: str | None = None
  householdId: str | None = None
  photoUrl: str | None = None
