import React, { useMemo, useState } from 'react';
import { ChevronLeft, ChevronRight, Pencil, Trash2 } from 'lucide-react';

export interface Column<T = any> {
  key: string;
  label: string;
  render?: (value: any, row: T) => React.ReactNode;
}

interface DataTableProps<T = any> {
  data: T[];
  columns: Column<T>[];
  loading?: boolean;
  onEdit?: (row: T) => void;
  onDelete?: (id: string) => void;
  pageSize?: number;
}

export default function DataTable<T extends { id: string }>({
  data,
  columns,
  loading,
  onEdit,
  onDelete,
  pageSize = 20,
}: DataTableProps<T>) {
  const [page, setPage] = useState(1);
  const totalPages = Math.max(1, Math.ceil(data.length / pageSize));
  const currentPage = Math.min(page, totalPages);
  const paginated = useMemo(
    () => data.slice((currentPage - 1) * pageSize, currentPage * pageSize),
    [currentPage, data, pageSize],
  );

  if (loading) {
    return (
      <div className="flex items-center justify-center rounded-lg border border-gray-100 bg-white p-12">
        <div className="h-8 w-8 animate-spin rounded-full border-2 border-green-700 border-t-transparent" />
      </div>
    );
  }

  return (
    <div className="overflow-hidden rounded-lg border border-gray-100 bg-white shadow-sm">
      <div className="overflow-x-auto">
        <table className="w-full min-w-[820px]">
          <thead className="border-b border-gray-100 bg-gray-50">
            <tr>
              <th className="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wider text-gray-500">#</th>
              {columns.map((column) => (
                <th key={column.key} className="px-4 py-3 text-left text-xs font-semibold uppercase tracking-wider text-gray-500">
                  {column.label}
                </th>
              ))}
              {(onEdit || onDelete) && (
                <th className="px-4 py-3 text-right text-xs font-semibold uppercase tracking-wider text-gray-500">
                  Actions
                </th>
              )}
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-50">
            {paginated.map((row, index) => (
              <tr key={row.id} className="hover:bg-gray-50">
                <td className="px-4 py-3 text-sm text-gray-400">
                  {(currentPage - 1) * pageSize + index + 1}
                </td>
                {columns.map((column) => (
                  <td key={column.key} className="px-4 py-3 text-sm text-gray-700">
                    {column.render
                      ? column.render((row as any)[column.key], row)
                      : String((row as any)[column.key] ?? '-')}
                  </td>
                ))}
                {(onEdit || onDelete) && (
                  <td className="px-4 py-3 text-right">
                    <div className="flex justify-end gap-2">
                      {onEdit && (
                        <button
                          type="button"
                          title="Edit"
                          onClick={() => onEdit(row)}
                          className="rounded-lg p-2 text-blue-600 hover:bg-blue-50"
                        >
                          <Pencil size={16} />
                        </button>
                      )}
                      {onDelete && (
                        <button
                          type="button"
                          title="Delete"
                          onClick={() => onDelete(row.id)}
                          className="rounded-lg p-2 text-red-600 hover:bg-red-50"
                        >
                          <Trash2 size={16} />
                        </button>
                      )}
                    </div>
                  </td>
                )}
              </tr>
            ))}
            {!paginated.length && (
              <tr>
                <td colSpan={columns.length + 2} className="px-4 py-10 text-center text-sm text-gray-500">
                  No records found.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

      {totalPages > 1 && (
        <div className="flex items-center justify-between border-t border-gray-100 px-4 py-3">
          <span className="text-sm text-gray-500">
            Showing {(currentPage - 1) * pageSize + 1}-{Math.min(currentPage * pageSize, data.length)} of {data.length}
          </span>
          <div className="flex gap-1">
            <button
              type="button"
              title="Previous page"
              onClick={() => setPage((value) => Math.max(1, value - 1))}
              disabled={currentPage === 1}
              className="rounded-lg border border-gray-200 p-2 text-gray-600 disabled:opacity-40 hover:bg-gray-50"
            >
              <ChevronLeft size={16} />
            </button>
            <button
              type="button"
              title="Next page"
              onClick={() => setPage((value) => Math.min(totalPages, value + 1))}
              disabled={currentPage === totalPages}
              className="rounded-lg border border-gray-200 p-2 text-gray-600 disabled:opacity-40 hover:bg-gray-50"
            >
              <ChevronRight size={16} />
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
