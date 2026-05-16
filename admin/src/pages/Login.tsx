import React, { FormEvent, useState } from 'react';
import { Navigate } from 'react-router-dom';
import toast from 'react-hot-toast';
import { Lock, LogIn, Mail, Recycle } from 'lucide-react';
import { useAuth } from '../hooks/useAuth';

export default function Login() {
  const { user, loading, signIn } = useAuth();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [submitting, setSubmitting] = useState(false);

  if (!loading && user) return <Navigate to="/" replace />;

  async function submit(event: FormEvent) {
    event.preventDefault();
    setSubmitting(true);
    try {
      await signIn(email, password);
      toast.success('Signed in');
    } catch (error: any) {
      toast.error(error?.message || 'Sign in failed');
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <div className="flex min-h-screen items-center justify-center bg-wbis-surface p-4">
      <form onSubmit={submit} className="w-full max-w-md rounded-lg border border-gray-100 bg-white p-6 shadow-sm">
        <div className="mb-6 flex items-center gap-3">
          <div className="rounded-lg bg-green-700 p-3 text-white">
            <Recycle size={24} />
          </div>
          <div>
            <h1 className="text-2xl font-extrabold text-gray-900">WBIS Admin</h1>
            <p className="text-sm text-gray-500">Secure operations console</p>
          </div>
        </div>
        <label className="mb-3 block">
          <span className="mb-1 block text-sm font-semibold text-gray-600">Email</span>
          <div className="flex items-center rounded-lg border border-gray-200 px-3 focus-within:border-green-700">
            <Mail size={16} className="text-gray-400" />
            <input
              type="email"
              value={email}
              onChange={(event) => setEmail(event.target.value)}
              className="w-full border-0 px-3 py-3 text-sm outline-none"
              required
            />
          </div>
        </label>
        <label className="block">
          <span className="mb-1 block text-sm font-semibold text-gray-600">Password</span>
          <div className="flex items-center rounded-lg border border-gray-200 px-3 focus-within:border-green-700">
            <Lock size={16} className="text-gray-400" />
            <input
              type="password"
              value={password}
              onChange={(event) => setPassword(event.target.value)}
              className="w-full border-0 px-3 py-3 text-sm outline-none"
              required
            />
          </div>
        </label>
        <button
          type="submit"
          disabled={submitting}
          className="mt-6 flex w-full items-center justify-center gap-2 rounded-lg bg-green-700 px-4 py-3 text-sm font-bold text-white hover:bg-green-800 disabled:opacity-50"
        >
          <LogIn size={16} />
          {submitting ? 'Signing in...' : 'Sign in'}
        </button>
      </form>
    </div>
  );
}
