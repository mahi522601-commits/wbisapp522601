import io
import pandas as pd
from .firebase_service import FirebaseService
from ..utils.csv_exporter import rows_to_csv


class ExportService:
  @staticmethod
  async def export_csv(
      collection: str,
      from_date: str | None = None,
      to_date: str | None = None,
  ) -> str:
    rows = await FirebaseService.list_documents(collection, from_date, to_date)
    return rows_to_csv(rows)

  @staticmethod
  async def export_excel(collection: str) -> bytes:
    rows = await FirebaseService.list_documents(collection)
    buffer = io.BytesIO()
    with pd.ExcelWriter(buffer, engine="openpyxl") as writer:
      pd.DataFrame(rows).to_excel(writer, index=False, sheet_name="WBIS Data")
    buffer.seek(0)
    return buffer.read()
