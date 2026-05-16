import React, { useMemo, useState } from 'react';
import { serverTimestamp } from 'firebase/firestore';
import AdvancedExport from '../components/export/AdvancedExport';
import AddModal from '../components/modals/AddModal';
import DeleteModal from '../components/modals/DeleteModal';
import EditModal from '../components/modals/EditModal';
import DataTable, { Column } from '../components/tables/DataTable';
import ImageViewer from '../components/ui/ImageViewer';
import StatCard from '../components/ui/StatCard';
import { AlertTriangle, CheckCircle2, Clock, ClipboardList } from 'lucide-react';
import { useCollection } from '../hooks/useFirestore';
import { FirestoreService } from '../services/firestoreService';
import { Survey, WasteStatus } from '../types/survey';
import { formatDate } from '../utils/dateFormatter';
import { STATUS_COLORS, STATUS_LABELS } from '../utils/constants';

export default function Surveys() {
  const { data: surveys, loading } = useCollection<Survey>('surveys', 'createdAt');
  const [editItem, setEditItem] = useState<Survey | null>(null);
  const [deleteId, setDeleteId] = useState<string | null>(null);
  const [viewImage, setViewImage] = useState<string | null>(null);
  const [showAdd, setShowAdd] = useState(false);
  const [search, setSearch] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');

  const filtered = useMemo(
    () =>
      surveys.filter((survey) => {
        const matchSearch = [survey.wardName, survey.city, survey.userId, survey.householdId]
          .join(' ')
          .toLowerCase()
          .includes(search.toLowerCase());
        const matchStatus = statusFilter === 'all' || survey.status === statusFilter;
        return matchSearch && matchStatus;
      }),
    [search, statusFilter, surveys],
  );

  const columns: Column<Survey>[] = [
    { key: 'wardName', label: 'Ward' },
    { key: 'city', label: 'City' },
    {
      key: 'status',
      label: 'Status',
      render: (value, row) => (
        <span className={`rounded-full border px-2 py-1 text-xs font-bold ${STATUS_COLORS[row.colorCode] || STATUS_COLORS.RED}`}>
          {STATUS_LABELS[value] || value}
        </span>
      ),
    },
    {
      key: 'behaviourScore',
      label: 'Score',
      render: (value) => <span className={`font-bold ${value >= 0 ? 'text-green-700' : 'text-red-600'}`}>{value > 0 ? '+' : ''}{value}</span>,
    },
    {
      key: 'photoUrl',
      label: 'Photo',
      render: (value) =>
        value ? (
          <button type="button" onClick={() => setViewImage(value)} className="font-semibold text-blue-600 hover:underline">
            View
          </button>
        ) : (
          <span className="text-gray-400">None</span>
        ),
    },
    { key: 'isValidated', label: 'Validated', render: (value) => (value ? 'Yes' : 'Pending') },
    { key: 'createdAt', label: 'Date', render: (value) => formatDate(value) },
  ];

  return (
    <div className="space-y-6">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <h1 className="text-2xl font-bold text-gray-900">Surveys</h1>
        <button type="button" onClick={() => setShowAdd(true)} className="rounded-lg bg-green-700 px-4 py-2 text-sm font-bold text-white hover:bg-green-800">
          Add Survey
        </button>
      </div>

      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <StatCard label="Total" value={surveys.length} icon={ClipboardList} tone="blue" />
        <StatCard label="Proper" value={surveys.filter((survey) => survey.status === 'proper').length} icon={CheckCircle2} tone="green" />
        <StatCard label="Pending" value={surveys.filter((survey) => !survey.isValidated).length} icon={Clock} tone="orange" />
        <StatCard label="Hazardous" value={surveys.filter((survey) => survey.status === 'hazardous').length} icon={AlertTriangle} tone="red" />
      </div>

      <div className="flex flex-wrap gap-3">
        <input
          type="text"
          placeholder="Search ward, city, user, household..."
          value={search}
          onChange={(event) => setSearch(event.target.value)}
          className="min-w-[220px] flex-1 rounded-lg border border-gray-200 px-4 py-2 text-sm outline-none focus:border-green-700"
        />
        <select value={statusFilter} onChange={(event) => setStatusFilter(event.target.value)} className="rounded-lg border border-gray-200 px-4 py-2 text-sm">
          <option value="all">All Statuses</option>
          <option value="proper">Proper</option>
          <option value="minorMixing">Minor Mixing</option>
          <option value="mixedWaste">Mixed Waste</option>
          <option value="hazardous">Hazardous</option>
        </select>
      </div>

      <DataTable data={filtered} columns={columns} loading={loading} onEdit={setEditItem} onDelete={setDeleteId} />
      <AdvancedExport />

      {editItem && (
        <EditModal
          item={editItem}
          collection="surveys"
          onClose={() => setEditItem(null)}
          onSave={(id, data) => FirestoreService.update('surveys', id, normalizeSurvey(data))}
        />
      )}
      {deleteId && (
        <DeleteModal
          onClose={() => setDeleteId(null)}
          onConfirm={async () => {
            await FirestoreService.remove('surveys', deleteId);
            setDeleteId(null);
          }}
        />
      )}
      {showAdd && (
        <AddModal
          title="Survey"
          fields={['userId', 'householdId', 'wardName', 'city', 'status', 'latitude', 'longitude', 'photoUrl']}
          onClose={() => setShowAdd(false)}
          onSave={(data) => FirestoreService.add('surveys', { ...normalizeSurvey(data), isValidated: false, createdAt: serverTimestamp() })}
        />
      )}
      {viewImage && <ImageViewer url={viewImage} onClose={() => setViewImage(null)} />}
    </div>
  );
}

function normalizeSurvey(data: Record<string, any>) {
  const status = (data.status || 'proper') as WasteStatus;
  const scoreMap: Record<WasteStatus, number> = { proper: 10, minorMixing: 5, mixedWaste: -5, hazardous: -15 };
  const colorMap: Record<WasteStatus, string> = { proper: 'GREEN', minorMixing: 'YELLOW', mixedWaste: 'RED', hazardous: 'BLACK' };
  return {
    ...data,
    status,
    colorCode: colorMap[status],
    behaviourScore: Number(data.behaviourScore ?? scoreMap[status]),
    latitude: Number(data.latitude ?? 0),
    longitude: Number(data.longitude ?? 0),
  };
}
