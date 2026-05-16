import React from 'react';
import { LucideIcon } from 'lucide-react';

const toneClasses = {
  green: 'bg-green-50 text-green-700 border-green-100',
  blue: 'bg-blue-50 text-blue-700 border-blue-100',
  orange: 'bg-orange-50 text-orange-700 border-orange-100',
  red: 'bg-red-50 text-red-700 border-red-100',
  gray: 'bg-gray-50 text-gray-700 border-gray-100',
};

export default function StatCard({
  label,
  value,
  icon: Icon,
  tone = 'gray',
}: {
  label: string;
  value: React.ReactNode;
  icon: LucideIcon;
  tone?: keyof typeof toneClasses;
}) {
  return (
    <div className="rounded-lg border border-gray-100 bg-white p-4 shadow-sm">
      <div className="flex items-center justify-between gap-3">
        <div>
          <p className="text-xs font-semibold uppercase tracking-wider text-gray-500">{label}</p>
          <p className="mt-1 text-2xl font-bold text-gray-900">{value}</p>
        </div>
        <div className={`rounded-lg border p-2 ${toneClasses[tone]}`}>
          <Icon size={20} />
        </div>
      </div>
    </div>
  );
}
