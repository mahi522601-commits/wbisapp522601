import React from 'react';
import { Bar, BarChart, ResponsiveContainer, Tooltip, XAxis, YAxis } from 'recharts';

export default function ScoreTrendChart({
  data,
}: {
  data: Array<{ label: string; value: number }>;
}) {
  return (
    <div className="h-72 rounded-lg border border-gray-100 bg-white p-4 shadow-sm">
      <h2 className="mb-4 text-base font-bold text-gray-900">Top Scores</h2>
      <ResponsiveContainer width="100%" height="85%">
        <BarChart data={data}>
          <XAxis dataKey="label" tick={{ fontSize: 12 }} />
          <YAxis tick={{ fontSize: 12 }} />
          <Tooltip />
          <Bar dataKey="value" fill="#1B5E20" radius={[6, 6, 0, 0]} />
        </BarChart>
      </ResponsiveContainer>
    </div>
  );
}
