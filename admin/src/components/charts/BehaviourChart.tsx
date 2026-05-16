import React from 'react';
import { Line, LineChart, ResponsiveContainer, Tooltip, XAxis, YAxis } from 'recharts';

export default function BehaviourChart({
  data,
}: {
  data: Array<{ label: string; score: number }>;
}) {
  return (
    <div className="h-72 rounded-lg border border-gray-100 bg-white p-4 shadow-sm">
      <h2 className="mb-4 text-base font-bold text-gray-900">Behaviour Score Trend</h2>
      <ResponsiveContainer width="100%" height="85%">
        <LineChart data={data}>
          <XAxis dataKey="label" tick={{ fontSize: 12 }} />
          <YAxis tick={{ fontSize: 12 }} />
          <Tooltip />
          <Line type="monotone" dataKey="score" stroke="#1B5E20" strokeWidth={3} dot={false} />
        </LineChart>
      </ResponsiveContainer>
    </div>
  );
}
