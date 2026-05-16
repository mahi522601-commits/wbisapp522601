import React, { useMemo, useState } from 'react';
import { serverTimestamp } from 'firebase/firestore';
import AddModal from '../components/modals/AddModal';
import DeleteModal from '../components/modals/DeleteModal';
import EditModal from '../components/modals/EditModal';
import DataTable, { Column } from '../components/tables/DataTable';
import ImageViewer from '../components/ui/ImageViewer';
import Badge from '../components/ui/Badge';
import { useCollection } from '../hooks/useFirestore';
import { FirestoreService } from '../services/firestoreService';
import { WasteReport } from '../types/report';
import { formatDate } from '../utils/dateFormatter';

export default function Reports() {
  const { data: reports, loading } = useCollection<WasteReport>('waste_reports', 'createdAt');
  const [search, setSearch] = useState('');
  const [editItem, setEditItem] = useState<WasteReport | null>(null);
  const [deleteId, setDeleteId] = useState<string | null>(null);
  const [viewImage, setViewImage] = useState<string | null>(null);
  const [showAdd, setShowAdd] = useState(false);

  const filtered = useMemo(
    () =>
      reports.filter((report) =>
        [report.description, report.city, report.wardName, report.status, report.category]
          .join(' ')
          .toLowerCase()
          .includes(search.toLowerCase()),
      ),
    [reports, search],
  );

  const columns: Column<WasteReport>[] = [
    { key: 'description', label: 'Description' },
    { key: 'category', label: 'Category' },
    { key: 'wardName', label: 'Ward' },
    { key: 'city', label: 'City' },
    { key: 'status', label: 'Status', render: (value) => <Badge tone={value === 'resolved' ? 'green' : value === 'rejected' ? 'red' : 'yellow'}>{value}</Badge> },
    {
      key: 'photoUrl',
      label: 'Photo',
      render: (value) =>
        value ? (
          <button type="button" onClick={() => setViewImage(value)} className="font-semibold text-blue-600 hover:underline">View</button>
        ) : (
          <span className="text-gray-400">None</span>
        ),
    },
    { key: 'createdAt', label: 'Date', render: (value) => formatDate(value) },
  ];

  return (
    <div className="space-y-5">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <h1 className="text-2xl font-bold text-gray-900">Waste Reports</h1>
        <button type="button" onClick={() => setShowAdd(true)} className="rounded-lg bg-green-700 px-4 py-2 text-sm font-bold text-white hover:bg-green-800">
          Add Report
        </button>
      </div>
      <input value={search} onChange={(event) => setSearch(event.target.value)} placeholder="Search reports..." className="w-full rounded-lg border border-gray-200 px-4 py-2 text-sm outline-none focus:border-green-700" />
      <DataTable data={filtered} columns={columns} loading={loading} onEdit={setEditItem} onDelete={setDeleteId} />
      {editItem && <EditModal item={editItem} collection="waste_reports" onClose={() => setEditItem(null)} onSave={(id, data) => FirestoreService.update('waste_reports', id, data)} />}
      {deleteId && <DeleteModal onClose={() => setDeleteId(null)} onConfirm={async () => { await FirestoreService.remove('waste_reports', deleteId); setDeleteId(null); }} />}
      {showAdd && <AddModal title="Report" fields={['userId', 'category', 'status', 'description', 'wardName', 'city', 'latitude', 'longitude', 'photoUrl']} onClose={() => setShowAdd(false)} onSave={(data) => FirestoreService.add('waste_reports', { ...data, createdAt: serverTimestamp() })} />}
      {viewImage && <ImageViewer url={viewImage} onClose={() => setViewImage(null)} />}
    </div>
  );
}
