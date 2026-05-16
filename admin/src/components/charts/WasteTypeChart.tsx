import React from 'react';
import { Cell, Pie, PieChart, ResponsiveContainer, Tooltip } from 'recharts';

const COLORS: Record<string, string> = {
  proper: '#16a34a',
  minorMixing: '#f59e0b',
  mixedWaste: '#dc2626',
  hazardous: '#27272a',
};

export default function WasteTypeChart({
  data,
}: {
  data: Array<{ name: string; value: number }>;
}) {
  return (
    <div className="h-72 rounded-lg border border-gray-100 bg-white p-4 shadow-sm">
      <h2 className="mb-4 text-base font-bold text-gray-900">Waste Status Mix</h2>
      <ResponsiveContainer width="100%" height="85%">
        <PieChart>
          <Pie data={data} dataKey="value" nameKey="name" innerRadius={55} outerRadius={90} paddingAngle={3}>
            {data.map((item) => (
              <Cell key={item.name} fill={COLORS[item.name] || '#64748b'} />
            ))}
          </Pie>
          <Tooltip />
        </PieChart>
      </ResponsiveContainer>
    </div>
  );
}
