import React, { useMemo, useState } from 'react';
import { Download } from 'lucide-react';
import { ExportFormat } from '../../services/exportService';
import { useExport } from '../../hooks/useExport';

const COLLECTIONS = [
  { id: 'surveys', label: 'Surveys' },
  { id: 'users', label: 'Users' },
  { id: 'waste_reports', label: 'Waste Reports' },
  { id: 'behaviour_scores', label: 'Scores' },
  { id: 'workers', label: 'Workers' },
];

const COLUMN_SETS: Record<string, string[]> = {
  surveys: [
    'id',
    'userId',
    'householdId',
    'wardName',
    'city',
    'status',
    'colorCode',
    'behaviourScore',
    'isValidated',
    'latitude',
    'longitude',
    'photoUrl',
    'workerNotes',
    'createdAt',
  ],
  users: ['id', 'uid', 'email', 'displayName', 'phone', 'role', 'wardName', 'city', 'householdId', 'createdAt'],
  waste_reports: ['id', 'userId', 'category', 'status', 'description', 'wardName', 'city', 'photoUrl', 'createdAt'],
  behaviour_scores: ['id', 'userId', 'totalScore', 'surveyCount', 'ecoPoints', 'lastUpdated'],
  workers: ['id', 'userId', 'name', 'wardAssigned', 'routeCompleted', 'missedHouseholds', 'reportingAccuracy', 'lastActive'],
};

export default function AdvancedExport() {
  const [selectedCollection, setSelectedCollection] = useState('surveys');
  const [format, setFormat] = useState<ExportFormat>('csv');
  const [dateFrom, setDateFrom] = useState('');
  const [dateTo, setDateTo] = useState('');
  const [selectedColumns, setSelectedColumns] = useState<string[]>(COLUMN_SETS.surveys);
  const { exportData, isExporting } = useExport();

  const columns = useMemo(() => COLUMN_SETS[selectedCollection] || [], [selectedCollection]);

  function setCollection(collectionId: string) {
    setSelectedCollection(collectionId);
    setSelectedColumns(COLUMN_SETS[collectionId] || []);
  }

  function toggleColumn(column: string) {
    setSelectedColumns((prev) =>
      prev.includes(column) ? prev.filter((item) => item !== column) : [...prev, column],
    );
  }

  return (
    <div className="rounded-lg border border-gray-100 bg-white p-5 shadow-sm">
      <div className="flex items-center justify-between gap-3">
        <h2 className="text-lg font-bold text-gray-900">Advanced Export</h2>
        <Download size={18} className="text-green-700" />
      </div>

      <div className="mt-5 grid gap-5 lg:grid-cols-2">
        <section>
          <label className="mb-2 block text-sm font-semibold text-gray-600">Collection</label>
          <div className="flex flex-wrap gap-2">
            {COLLECTIONS.map((collection) => (
              <button
                key={collection.id}
                type="button"
                onClick={() => setCollection(collection.id)}
                className={`rounded-lg px-3 py-2 text-sm font-semibold ${
                  selectedCollection === collection.id
                    ? 'bg-green-700 text-white'
                    : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                }`}
              >
                {collection.label}
              </button>
            ))}
          </div>
        </section>

        <section>
          <label className="mb-2 block text-sm font-semibold text-gray-600">Format</label>
          <div className="flex flex-wrap gap-2">
            {(['csv', 'json', 'excel'] as ExportFormat[]).map((item) => (
              <button
                key={item}
                type="button"
                onClick={() => setFormat(item)}
                className={`rounded-lg px-3 py-2 text-sm font-semibold uppercase ${
                  format === item ? 'bg-blue-600 text-white' : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                }`}
              >
                {item}
              </button>
            ))}
          </div>
        </section>
      </div>

      <div className="mt-5 grid gap-4 sm:grid-cols-2">
        <label>
          <span className="mb-1 block text-sm font-semibold text-gray-600">From</span>
          <input type="date" value={dateFrom} onChange={(event) => setDateFrom(event.target.value)} className="w-full rounded-lg border border-gray-200 px-3 py-2 text-sm" />
        </label>
        <label>
          <span className="mb-1 block text-sm font-semibold text-gray-600">To</span>
          <input type="date" value={dateTo} onChange={(event) => setDateTo(event.target.value)} className="w-full rounded-lg border border-gray-200 px-3 py-2 text-sm" />
        </label>
      </div>

      <section className="mt-5">
        <label className="mb-2 block text-sm font-semibold text-gray-600">Columns ({selectedColumns.length})</label>
        <div className="flex max-h-36 flex-wrap gap-2 overflow-y-auto rounded-lg bg-gray-50 p-2">
          {columns.map((column) => (
            <button
              key={column}
              type="button"
              onClick={() => toggleColumn(column)}
              className={`rounded-full border px-3 py-1 text-xs font-semibold ${
                selectedColumns.includes(column)
                  ? 'border-green-300 bg-green-100 text-green-800'
                  : 'border-gray-200 bg-white text-gray-500'
              }`}
            >
              {column}
            </button>
          ))}
        </div>
      </section>

      <button
        type="button"
        onClick={() =>
          exportData({
            collection: selectedCollection,
            format,
            columns: selectedColumns,
            dateRange: dateFrom && dateTo ? { from: new Date(dateFrom), to: new Date(dateTo) } : undefined,
            filename: `wbis_${selectedCollection}_export`,
          })
        }
        disabled={isExporting}
        className="mt-5 flex w-full items-center justify-center gap-2 rounded-lg bg-green-700 px-4 py-3 text-sm font-bold text-white hover:bg-green-800 disabled:opacity-50"
      >
        <Download size={16} />
        {isExporting ? 'Exporting...' : `Export ${format.toUpperCase()}`}
      </button>
    </div>
  );
}
