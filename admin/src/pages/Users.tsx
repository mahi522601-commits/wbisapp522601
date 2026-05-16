import React, { useMemo, useState } from 'react';
import { serverTimestamp } from 'firebase/firestore';
import AddModal from '../components/modals/AddModal';
import DeleteModal from '../components/modals/DeleteModal';
import EditModal from '../components/modals/EditModal';
import DataTable, { Column } from '../components/tables/DataTable';
import Badge from '../components/ui/Badge';
import { useCollection } from '../hooks/useFirestore';
import { FirestoreService } from '../services/firestoreService';
import { WBISUser } from '../types/user';
import { formatDate } from '../utils/dateFormatter';

export default function Users() {
  const { data: users, loading } = useCollection<WBISUser>('users', 'createdAt');
  const [search, setSearch] = useState('');
  const [editItem, setEditItem] = useState<WBISUser | null>(null);
  const [deleteId, setDeleteId] = useState<string | null>(null);
  const [showAdd, setShowAdd] = useState(false);

  const filtered = useMemo(
    () =>
      users.filter((user) =>
        [user.displayName, user.email, user.role, user.wardName, user.city]
          .join(' ')
          .toLowerCase()
          .includes(search.toLowerCase()),
      ),
    [search, users],
  );

  const columns: Column<WBISUser>[] = [
    { key: 'displayName', label: 'Name' },
    { key: 'email', label: 'Email' },
    { key: 'phone', label: 'Phone' },
    {
      key: 'role',
      label: 'Role',
      render: (value) => <Badge tone={value === 'admin' ? 'blue' : value === 'worker' ? 'green' : 'gray'}>{value}</Badge>,
    },
    { key: 'wardName', label: 'Ward' },
    { key: 'city', label: 'City' },
    { key: 'createdAt', label: 'Created', render: (value) => formatDate(value) },
  ];

  return (
    <div className="space-y-5">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <h1 className="text-2xl font-bold text-gray-900">Users</h1>
        <button type="button" onClick={() => setShowAdd(true)} className="rounded-lg bg-green-700 px-4 py-2 text-sm font-bold text-white hover:bg-green-800">
          Add User
        </button>
      </div>

      <input
        value={search}
        onChange={(event) => setSearch(event.target.value)}
        placeholder="Search name, email, role, ward..."
        className="w-full rounded-lg border border-gray-200 px-4 py-2 text-sm outline-none focus:border-green-700"
      />

      <DataTable data={filtered} columns={columns} loading={loading} onEdit={setEditItem} onDelete={setDeleteId} />

      {editItem && (
        <EditModal
          item={editItem}
          collection="users"
          onClose={() => setEditItem(null)}
          onSave={(id, data) => FirestoreService.update('users', id, data)}
        />
      )}
      {deleteId && (
        <DeleteModal
          onClose={() => setDeleteId(null)}
          onConfirm={async () => {
            await FirestoreService.remove('users', deleteId);
            setDeleteId(null);
          }}
        />
      )}
      {showAdd && (
        <AddModal
          title="User"
          fields={['uid', 'email', 'displayName', 'phone', 'role', 'wardName', 'city', 'householdId']}
          onClose={() => setShowAdd(false)}
          onSave={(data) => FirestoreService.add('users', { ...data, createdAt: serverTimestamp() })}
        />
      )}
    </div>
  );
}
