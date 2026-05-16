import React from 'react';
import { AlertTriangle } from 'lucide-react';

export default function DeleteModal({
  onClose,
  onConfirm,
}: {
  onClose: () => void;
  onConfirm: () => Promise<void>;
}) {
  return (
    <div className="fixed inset-0 z-40 flex items-center justify-center bg-black/40 p-4">
      <div className="w-full max-w-md rounded-lg bg-white p-6 shadow-xl">
        <div className="flex items-start gap-3">
          <div className="rounded-lg bg-red-50 p-2 text-red-600">
            <AlertTriangle size={22} />
          </div>
          <div>
            <h2 className="text-lg font-bold text-gray-900">Delete record</h2>
            <p className="mt-1 text-sm text-gray-600">This action removes the selected Firestore document.</p>
          </div>
        </div>
        <div className="mt-6 flex justify-end gap-2">
          <button type="button" onClick={onClose} className="rounded-lg border border-gray-200 px-4 py-2 text-sm font-semibold text-gray-700 hover:bg-gray-50">
            Cancel
          </button>
          <button type="button" onClick={onConfirm} className="rounded-lg bg-red-600 px-4 py-2 text-sm font-semibold text-white hover:bg-red-700">
            Delete
          </button>
        </div>
      </div>
    </div>
  );
}
