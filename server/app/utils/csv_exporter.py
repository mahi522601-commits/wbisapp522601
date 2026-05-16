import csv
import io
from collections.abc import Iterable


def rows_to_csv(rows: Iterable[dict]) -> str:
  materialized = list(rows)
  if not materialized:
    return ""

  headers: list[str] = []
  for row in materialized:
    for key in row.keys():
      if key not in headers:
        headers.append(key)

  output = io.StringIO()
  writer = csv.DictWriter(output, fieldnames=headers)
  writer.writeheader()
  writer.writerows(materialized)
  return output.getvalue()
