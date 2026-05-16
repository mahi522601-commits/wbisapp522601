import React from 'react';
import { NavLink } from 'react-router-dom';
import {
  BarChart3,
  ClipboardList,
  Gauge,
  Home,
  Map,
  Recycle,
  Settings,
  Star,
  Users,
  Wrench,
} from 'lucide-react';

const items = [
  { to: '/', label: 'Dashboard', icon: Home },
  { to: '/users', label: 'Users', icon: Users },
  { to: '/surveys', label: 'Surveys', icon: ClipboardList },
  { to: '/reports', label: 'Reports', icon: Recycle },
  { to: '/workers', label: 'Workers', icon: Wrench },
  { to: '/scores', label: 'Scores', icon: Star },
  { to: '/heatmap', label: 'Heatmap', icon: Map },
  { to: '/analytics', label: 'Analytics', icon: BarChart3 },
  { to: '/settings', label: 'Settings', icon: Settings },
];

export default function Sidebar() {
  return (
    <aside className="hidden w-64 shrink-0 border-r border-gray-200 bg-white lg:block">
      <div className="flex h-16 items-center gap-3 border-b border-gray-100 px-5">
        <div className="rounded-lg bg-green-700 p-2 text-white">
          <Gauge size={20} />
        </div>
        <div>
          <p className="font-extrabold text-gray-900">WBIS</p>
          <p className="text-xs text-gray-500">Admin Console</p>
        </div>
      </div>
      <nav className="space-y-1 p-3">
        {items.map(({ to, label, icon: Icon }) => (
          <NavLink
            key={to}
            to={to}
            end={to === '/'}
            className={({ isActive }) =>
              `flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-semibold ${
                isActive ? 'bg-green-50 text-green-800' : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'
              }`
            }
          >
            <Icon size={18} />
            {label}
          </NavLink>
        ))}
      </nav>
    </aside>
  );
}
