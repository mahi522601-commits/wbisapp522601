import React, { useMemo, useState } from 'react';
import DataTable, { Column } from '../components/tables/DataTable';
import ScoreTrendChart from '../components/charts/ScoreTrendChart';
import { useCollection } from '../hooks/useFirestore';
import { BehaviourScore } from '../types/score';
import { formatDate } from '../utils/dateFormatter';

export default function Scores() {
  const { data: scores, loading } = useCollection<BehaviourScore>('behaviour_scores', 'totalScore');
  const [search, setSearch] = useState('');
  const filtered = useMemo(
    () => scores.filter((score) => score.userId.toLowerCase().includes(search.toLowerCase())),
    [scores, search],
  );

  const columns: Column<BehaviourScore>[] = [
    { key: 'userId', label: 'User' },
    { key: 'totalScore', label: 'Total Score', render: (value) => <span className="font-bold text-green-700">{value}</span> },
    { key: 'surveyCount', label: 'Surveys' },
    { key: 'ecoPoints', label: 'Eco Points' },
    { key: 'lastUpdated', label: 'Updated', render: (value) => formatDate(value) },
  ];

  return (
    <div className="space-y-5">
      <h1 className="text-2xl font-bold text-gray-900">Scores</h1>
      <ScoreTrendChart data={scores.slice(0, 10).map((score) => ({ label: score.userId.slice(0, 6), value: score.totalScore }))} />
      <input value={search} onChange={(event) => setSearch(event.target.value)} placeholder="Search user ID..." className="w-full rounded-lg border border-gray-200 px-4 py-2 text-sm outline-none focus:border-green-700" />
      <DataTable data={filtered} columns={columns} loading={loading} />
    </div>
  );
}
