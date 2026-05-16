import React from 'react';
import { LogOut, Shield } from 'lucide-react';
import { useAuth } from '../../hooks/useAuth';

export default function Header() {
  const { user, signOut } = useAuth();
  return (
    <header className="flex h-16 items-center justify-between border-b border-gray-200 bg-white px-4 lg:px-6">
      <div>
        <p className="text-sm font-semibold text-gray-500">Waste Behaviour Intelligence System</p>
        <h1 className="text-lg font-bold text-gray-900">Operations Dashboard</h1>
      </div>
      <div className="flex items-center gap-3">
        <div className="hidden items-center gap-2 rounded-lg bg-gray-50 px-3 py-2 text-sm text-gray-600 sm:flex">
          <Shield size={16} />
          {user?.email || 'Admin'}
        </div>
        <button type="button" title="Sign out" onClick={signOut} className="rounded-lg p-2 text-gray-600 hover:bg-gray-100">
          <LogOut size={18} />
        </button>
      </div>
    </header>
  );
}
