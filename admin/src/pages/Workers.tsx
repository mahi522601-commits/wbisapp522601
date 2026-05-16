import React, { useMemo, useState } from 'react';
import { serverTimestamp } from 'firebase/firestore';
import AddModal from '../components/modals/AddModal';
import DeleteModal from '../components/modals/DeleteModal';
import EditModal from '../components/modals/EditModal';
import DataTable, { Column } from '../components/tables/DataTable';
import { useCollection } from '../hooks/useFirestore';
import { FirestoreService } from '../services/firestoreService';
import { Worker } from '../types/worker';
import { formatDate } from '../utils/dateFormatter';

export default function Workers() {
  const { data: workers, loading } = useCollection<Worker>('workers', 'lastActive');
  const [search, setSearch] = useState('');
  const [editItem, setEditItem] = useState<Worker | null>(null);
  const [deleteId, setDeleteId] = useState<string | null>(null);
  const [showAdd, setShowAdd] = useState(false);

  const filtered = useMemo(
    () =>
      workers.filter((worker) =>
        [worker.name, worker.wardAssigned, worker.userId].join(' ').toLowerCase().includes(search.toLowerCase()),
      ),
    [search, workers],
  );

  const columns: Column<Worker>[] = [
    { key: 'name', label: 'Name' },
    { key: 'wardAssigned', label: 'Ward' },
    { key: 'routeCompleted', label: 'Routes' },
    { key: 'missedHouseholds', label: 'Missed' },
    { key: 'reportingAccuracy', label: 'Accuracy', render: (value) => `${value}%` },
    { key: 'lastActive', label: 'Last Active', render: (value) => formatDate(value) },
  ];

  return (
    <div className="space-y-5">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <h1 className="text-2xl font-bold text-gray-900">Workers</h1>
        <button type="button" onClick={() => setShowAdd(true)} className="rounded-lg bg-green-700 px-4 py-2 text-sm font-bold text-white hover:bg-green-800">
          Add Worker
        </button>
      </div>
      <input value={search} onChange={(event) => setSearch(event.target.value)} placeholder="Search workers..." className="w-full rounded-lg border border-gray-200 px-4 py-2 text-sm outline-none focus:border-green-700" />
      <DataTable data={filtered} columns={columns} loading={loading} onEdit={setEditItem} onDelete={setDeleteId} />
      {editItem && <EditModal item={editItem} collection="workers" onClose={() => setEditItem(null)} onSave={(id, data) => FirestoreService.update('workers', id, data)} />}
      {deleteId && <DeleteModal onClose={() => setDeleteId(null)} onConfirm={async () => { await FirestoreService.remove('workers', deleteId); setDeleteId(null); }} />}
      {showAdd && <AddModal title="Worker" fields={['userId', 'name', 'wardAssigned', 'routeCompleted', 'missedHouseholds', 'reportingAccuracy']} onClose={() => setShowAdd(false)} onSave={(data) => FirestoreService.add('workers', { ...data, lastActive: serverTimestamp() })} />}
    </div>
  );
}
