import React, { useMemo } from 'react';
import { AlertTriangle, ClipboardList, Recycle, Star, Users } from 'lucide-react';
import BehaviourChart from '../components/charts/BehaviourChart';
import ScoreTrendChart from '../components/charts/ScoreTrendChart';
import WasteTypeChart from '../components/charts/WasteTypeChart';
import StatCard from '../components/ui/StatCard';
import { useCollection } from '../hooks/useFirestore';
import { BehaviourScore } from '../types/score';
import { Survey } from '../types/survey';
import { WBISUser } from '../types/user';
import { WasteReport } from '../types/report';
import { formatDate } from '../utils/dateFormatter';

export default function Dashboard() {
  const { data: surveys } = useCollection<Survey>('surveys', 'createdAt');
  const { data: users } = useCollection<WBISUser>('users', 'createdAt');
  const { data: reports } = useCollection<WasteReport>('waste_reports', 'createdAt');
  const { data: scores } = useCollection<BehaviourScore>('behaviour_scores', 'totalScore');

  const wasteMix = useMemo(
    () =>
      ['proper', 'minorMixing', 'mixedWaste', 'hazardous'].map((status) => ({
        name: status,
        value: surveys.filter((survey) => survey.status === status).length,
      })),
    [surveys],
  );

  const trend = useMemo(() => {
    const ordered = [...surveys].reverse().slice(-12);
    let running = 0;
    return ordered.map((survey, index) => {
      running += survey.behaviourScore || 0;
      return { label: String(index + 1), score: running };
    });
  }, [surveys]);

  const topScores = scores.slice(0, 8).map((score) => ({
    label: score.userId.slice(0, 6),
    value: score.totalScore,
  }));

  return (
    <div className="space-y-6">
      <section className="grid gap-4 sm:grid-cols-2 xl:grid-cols-5">
        <StatCard label="Users" value={users.length} icon={Users} tone="blue" />
        <StatCard label="Surveys" value={surveys.length} icon={ClipboardList} tone="green" />
        <StatCard label="Reports" value={reports.length} icon={Recycle} tone="orange" />
        <StatCard label="Hazardous" value={surveys.filter((s) => s.status === 'hazardous').length} icon={AlertTriangle} tone="red" />
        <StatCard label="Avg Score" value={average(surveys.map((s) => s.behaviourScore))} icon={Star} tone="gray" />
      </section>

      <section className="grid gap-6 xl:grid-cols-3">
        <div className="xl:col-span-2">
          <BehaviourChart data={trend} />
        </div>
        <WasteTypeChart data={wasteMix} />
      </section>

      <section className="grid gap-6 xl:grid-cols-2">
        <ScoreTrendChart data={topScores} />
        <div className="rounded-lg border border-gray-100 bg-white p-4 shadow-sm">
          <h2 className="mb-4 text-base font-bold text-gray-900">Latest Surveys</h2>
          <div className="space-y-3">
            {surveys.slice(0, 6).map((survey) => (
              <div key={survey.id} className="flex items-center justify-between rounded-lg bg-gray-50 px-3 py-2">
                <div>
                  <p className="text-sm font-semibold text-gray-900">{survey.wardName || 'Unknown ward'}</p>
                  <p className="text-xs text-gray-500">{formatDate(survey.createdAt)}</p>
                </div>
                <span className="text-sm font-bold text-green-700">{survey.behaviourScore > 0 ? '+' : ''}{survey.behaviourScore}</span>
              </div>
            ))}
          </div>
        </div>
      </section>
    </div>
  );
}

function average(values: number[]) {
  if (!values.length) return 0;
  return Math.round(values.reduce((sum, value) => sum + (value || 0), 0) / values.length);
}
