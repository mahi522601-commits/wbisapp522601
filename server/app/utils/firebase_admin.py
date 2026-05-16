import json
import os
from functools import lru_cache
import firebase_admin
from firebase_admin import credentials, firestore, storage
from ..config import settings


def initialize_firebase() -> None:
  if firebase_admin._apps:
    return

  options = {
      "projectId": settings.firebase_project_id,
      "storageBucket": settings.firebase_storage_bucket,
  }

  try:
    if settings.service_account_json:
      cert = json.loads(settings.service_account_json)
      cred = credentials.Certificate(cert)
    elif settings.google_application_credentials and os.path.exists(
        settings.google_application_credentials
    ):
      cred = credentials.Certificate(settings.google_application_credentials)
    else:
      cred = credentials.ApplicationDefault()

    firebase_admin.initialize_app(cred, options)
  except Exception as exc:
    # Keep app startup friendly in local development; Firestore calls will still
    # surface credential problems clearly.
    print(f"Firebase initialization warning: {exc}")


@lru_cache(maxsize=1)
def get_firestore_client():
  initialize_firebase()
  return firestore.client()


@lru_cache(maxsize=1)
def get_storage_bucket():
  initialize_firebase()
  return storage.bucket()
