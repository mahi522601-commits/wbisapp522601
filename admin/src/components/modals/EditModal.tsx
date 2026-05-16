import React, { useState } from 'react';
import toast from 'react-hot-toast';
import { X } from 'lucide-react';

export default function EditModal({
  item,
  collection,
  onClose,
  onSave,
}: {
  item: Record<string, any>;
  collection: string;
  onClose: () => void;
  onSave: (id: string, data: Record<string, any>) => Promise<void>;
}) {
  const [form, setForm] = useState<Record<string, any>>(() => ({ ...item }));
  const editableKeys = Object.keys(item).filter((key) => key !== 'id');

  async function save() {
    try {
      const { id: _id, ...payload } = form;
      await onSave(item.id, coerce(payload));
      toast.success(`${collection} updated`);
      onClose();
    } catch (error: any) {
      toast.error(error?.message || 'Update failed');
    }
  }

  return (
    <div className="fixed inset-0 z-40 flex items-center justify-center bg-black/40 p-4">
      <div className="max-h-[90vh] w-full max-w-xl overflow-y-auto rounded-lg bg-white shadow-xl">
        <div className="flex items-center justify-between border-b border-gray-100 px-5 py-4">
          <h2 className="text-lg font-bold text-gray-900">Edit {collection}</h2>
          <button type="button" title="Close" onClick={onClose} className="rounded-lg p-2 hover:bg-gray-100">
            <X size={18} />
          </button>
        </div>
        <div className="space-y-3 p-5">
          {editableKeys.map((key) => (
            <label key={key} className="block">
              <span className="mb-1 block text-xs font-semibold uppercase tracking-wide text-gray-500">{key}</span>
              <input
                value={stringify(form[key])}
                onChange={(event) => setForm((prev) => ({ ...prev, [key]: event.target.value }))}
                className="w-full rounded-lg border border-gray-200 px-3 py-2 text-sm outline-none focus:border-green-700"
              />
            </label>
          ))}
        </div>
        <div className="flex justify-end gap-2 border-t border-gray-100 px-5 py-4">
          <button type="button" onClick={onClose} className="rounded-lg border border-gray-200 px-4 py-2 text-sm font-semibold text-gray-700 hover:bg-gray-50">
            Cancel
          </button>
          <button type="button" onClick={save} className="rounded-lg bg-green-700 px-4 py-2 text-sm font-semibold text-white hover:bg-green-800">
            Save
          </button>
        </div>
      </div>
    </div>
  );
}

function stringify(value: any) {
  if (value?.toDate) return value.toDate().toISOString();
  if (typeof value === 'object' && value !== null) return JSON.stringify(value);
  return value ?? '';
}

function coerce(values: Record<string, any>) {
  return Object.fromEntries(
    Object.entries(values).map(([key, value]) => {
      if (value === 'true') return [key, true];
      if (value === 'false') return [key, false];
      if (value !== '' && !Number.isNaN(Number(value)) && !key.toLowerCase().includes('id')) {
        return [key, Number(value)];
      }
      try {
        if (String(value).trim().startsWith('{')) return [key, JSON.parse(value)];
      } catch {
        return [key, value];
      }
      return [key, value];
    }),
  );
}
