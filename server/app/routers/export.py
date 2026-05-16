import io
from fastapi import APIRouter, Query
from fastapi.responses import StreamingResponse
from ..services.export_service import ExportService

router = APIRouter()


@router.get("/csv")
async def export_csv(
    collection: str = Query("surveys"),
    from_date: str | None = Query(None),
    to_date: str | None = Query(None),
):
  csv_data = await ExportService.export_csv(collection, from_date, to_date)
  return StreamingResponse(
      io.StringIO(csv_data),
      media_type="text/csv",
      headers={
          "Content-Disposition": f'attachment; filename="wbis_{collection}.csv"'
      },
  )


@router.get("/excel")
async def export_excel(collection: str = Query("surveys")):
  excel_bytes = await ExportService.export_excel(collection)
  return StreamingResponse(
      io.BytesIO(excel_bytes),
      media_type=(
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      ),
      headers={
          "Content-Disposition": f'attachment; filename="wbis_{collection}.xlsx"'
      },
  )
