import React from 'react';
import { CheckCircle2, Database, ShieldCheck } from 'lucide-react';
import StatCard from '../components/ui/StatCard';

export default function Settings() {
  const apiKeyConfigured = Boolean(import.meta.env.VITE_FIREBASE_API_KEY || import.meta.env.REACT_APP_FIREBASE_API_KEY);

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold text-gray-900">Settings</h1>
      <section className="grid gap-4 md:grid-cols-3">
        <StatCard label="Project" value="wbis-ba283" icon={Database} tone="green" />
        <StatCard label="Auth Domain" value="firebaseapp.com" icon={ShieldCheck} tone="blue" />
        <StatCard label="API Key" value={apiKeyConfigured ? 'Configured' : 'Missing'} icon={CheckCircle2} tone={apiKeyConfigured ? 'green' : 'orange'} />
      </section>
      <div className="rounded-lg border border-gray-100 bg-white p-5 shadow-sm">
        <h2 className="text-lg font-bold text-gray-900">Environment</h2>
        <dl className="mt-4 grid gap-3 text-sm md:grid-cols-2">
          <div className="rounded-lg bg-gray-50 p-3">
            <dt className="font-semibold text-gray-500">Project ID</dt>
            <dd className="mt-1 text-gray-900">{import.meta.env.VITE_FIREBASE_PROJECT_ID || 'wbis-ba283'}</dd>
          </div>
          <div className="rounded-lg bg-gray-50 p-3">
            <dt className="font-semibold text-gray-500">Storage Bucket</dt>
            <dd className="mt-1 text-gray-900">{import.meta.env.VITE_FIREBASE_STORAGE_BUCKET || 'wbis-ba283.firebasestorage.app'}</dd>
          </div>
          <div className="rounded-lg bg-gray-50 p-3">
            <dt className="font-semibold text-gray-500">Sender ID</dt>
            <dd className="mt-1 text-gray-900">{import.meta.env.VITE_FIREBASE_MESSAGING_SENDER_ID || '720453653584'}</dd>
          </div>
          <div className="rounded-lg bg-gray-50 p-3">
            <dt className="font-semibold text-gray-500">Admin Build</dt>
            <dd className="mt-1 text-gray-900">React + Firebase + Tailwind</dd>
          </div>
        </dl>
      </div>
    </div>
  );
}
