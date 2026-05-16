import React from 'react';
import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom';
import { useAuth } from './hooks/useAuth';
import Layout from './components/layout/Layout';
import Analytics from './pages/Analytics';
import Dashboard from './pages/Dashboard';
import Heatmap from './pages/Heatmap';
import Login from './pages/Login';
import Reports from './pages/Reports';
import Scores from './pages/Scores';
import Settings from './pages/Settings';
import Surveys from './pages/Surveys';
import Users from './pages/Users';
import Workers from './pages/Workers';

function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const { user, loading } = useAuth();
  if (loading) {
    return (
      <div className="flex h-screen items-center justify-center bg-wbis-surface">
        <div className="h-8 w-8 animate-spin rounded-full border-2 border-green-700 border-t-transparent" />
      </div>
    );
  }
  return user ? <>{children}</> : <Navigate to="/login" replace />;
}

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route
          path="/"
          element={
            <ProtectedRoute>
              <Layout />
            </ProtectedRoute>
          }
        >
          <Route index element={<Dashboard />} />
          <Route path="users" element={<Users />} />
          <Route path="surveys" element={<Surveys />} />
          <Route path="reports" element={<Reports />} />
          <Route path="workers" element={<Workers />} />
          <Route path="scores" element={<Scores />} />
          <Route path="heatmap" element={<Heatmap />} />
          <Route path="analytics" element={<Analytics />} />
          <Route path="settings" element={<Settings />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}
