import React, { useState } from 'react';
import toast from 'react-hot-toast';
import { X } from 'lucide-react';

export default function AddModal({
  title,
  fields,
  onClose,
  onSave,
}: {
  title: string;
  fields: string[];
  onClose: () => void;
  onSave: (data: Record<string, any>) => Promise<unknown>;
}) {
  const [form, setForm] = useState<Record<string, string>>({});

  async function save() {
    try {
      await onSave(
        Object.fromEntries(
          fields.map((field) => [field, coerceValue(form[field] ?? '')]),
        ),
      );
      toast.success(`${title} added`);
      onClose();
    } catch (error: any) {
      toast.error(error?.message || 'Create failed');
    }
  }

  return (
    <div className="fixed inset-0 z-40 flex items-center justify-center bg-black/40 p-4">
      <div className="max-h-[90vh] w-full max-w-lg overflow-y-auto rounded-lg bg-white shadow-xl">
        <div className="flex items-center justify-between border-b border-gray-100 px-5 py-4">
          <h2 className="text-lg font-bold text-gray-900">Add {title}</h2>
          <button type="button" title="Close" onClick={onClose} className="rounded-lg p-2 hover:bg-gray-100">
            <X size={18} />
          </button>
        </div>
        <div className="space-y-3 p-5">
          {fields.map((field) => (
            <label key={field} className="block">
              <span className="mb-1 block text-xs font-semibold uppercase tracking-wide text-gray-500">{field}</span>
              <input
                value={form[field] ?? ''}
                onChange={(event) => setForm((prev) => ({ ...prev, [field]: event.target.value }))}
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
            Add
          </button>
        </div>
      </div>
    </div>
  );
}

function coerceValue(value: string) {
  if (value === 'true') return true;
  if (value === 'false') return false;
  if (value !== '' && !Number.isNaN(Number(value))) return Number(value);
  return value;
}
