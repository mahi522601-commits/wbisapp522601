import os
from dataclasses import dataclass
from dotenv import load_dotenv

load_dotenv()


@dataclass(frozen=True)
class Settings:
  firebase_project_id: str = os.getenv("FIREBASE_PROJECT_ID", "wbis-ba283")
  firebase_storage_bucket: str = os.getenv(
      "FIREBASE_STORAGE_BUCKET",
      "wbis-ba283.firebasestorage.app",
  )
  service_account_json: str = os.getenv("FIREBASE_SERVICE_ACCOUNT_JSON", "")
  google_application_credentials: str = os.getenv(
      "GOOGLE_APPLICATION_CREDENTIALS",
      "",
  )
  cors_origins: tuple[str, ...] = tuple(
      origin.strip()
      for origin in os.getenv(
          "CORS_ORIGINS",
          "http://localhost:5173,http://127.0.0.1:5173",
      ).split(",")
      if origin.strip()
  )


settings = Settings()
