from datetime import datetime
from typing import Any
from firebase_admin import firestore
from ..utils.firebase_admin import get_firestore_client


class FirebaseService:
  @staticmethod
  def db():
    return get_firestore_client()

  @classmethod
  async def list_documents(
      cls,
      collection: str,
      from_date: str | None = None,
      to_date: str | None = None,
      limit: int | None = None,
  ) -> list[dict[str, Any]]:
    query = cls.db().collection(collection)

    if from_date:
      query = query.where("createdAt", ">=", _parse_date(from_date))
    if to_date:
      query = query.where("createdAt", "<=", _parse_date(to_date))

    order_field = _default_order_field(collection)
    if order_field:
      query = query.order_by(order_field, direction=firestore.Query.DESCENDING)

    if limit:
      query = query.limit(limit)

    return [_doc_to_dict(doc) for doc in query.stream()]

  @classmethod
  async def get_document(cls, collection: str, doc_id: str) -> dict | None:
    snap = cls.db().collection(collection).document(doc_id).get()
    return _doc_to_dict(snap) if snap.exists else None

  @classmethod
  async def create_document(
      cls,
      collection: str,
      data: dict[str, Any],
      doc_id: str | None = None,
  ) -> str:
    if doc_id:
      cls.db().collection(collection).document(doc_id).set(data)
      return doc_id
    ref = cls.db().collection(collection).document()
    ref.set(data)
    return ref.id

  @classmethod
  async def update_document(
      cls,
      collection: str,
      doc_id: str,
      data: dict[str, Any],
  ) -> None:
    clean = {key: value for key, value in data.items() if value is not None}
    cls.db().collection(collection).document(doc_id).update(clean)

  @classmethod
  async def delete_document(cls, collection: str, doc_id: str) -> None:
    cls.db().collection(collection).document(doc_id).delete()


def _parse_date(value: str) -> datetime:
  return datetime.fromisoformat(value.replace("Z", "+00:00"))


def _doc_to_dict(doc) -> dict[str, Any]:
  data = doc.to_dict() or {}
  normalized = _normalize(data)
  normalized["id"] = doc.id
  return normalized


def _normalize(value):
  if isinstance(value, datetime):
    return value.isoformat()
  if isinstance(value, dict):
    return {key: _normalize(item) for key, item in value.items()}
  if isinstance(value, list):
    return [_normalize(item) for item in value]
  return value


def _default_order_field(collection: str) -> str | None:
  if collection == "behaviour_scores":
    return "totalScore"
  if collection == "workers":
    return "lastActive"
  if collection == "analytics":
    return "date"
  return "createdAt"
