import React, { useMemo } from 'react';
import BehaviourChart from '../components/charts/BehaviourChart';
import WasteTypeChart from '../components/charts/WasteTypeChart';
import ScoreTrendChart from '../components/charts/ScoreTrendChart';
import { useCollection } from '../hooks/useFirestore';
import { BehaviourScore } from '../types/score';
import { Survey } from '../types/survey';

export default function Analytics() {
  const { data: surveys } = useCollection<Survey>('surveys', 'createdAt');
  const { data: scores } = useCollection<BehaviourScore>('behaviour_scores', 'totalScore');

  const statusData = useMemo(
    () =>
      ['proper', 'minorMixing', 'mixedWaste', 'hazardous'].map((status) => ({
        name: status,
        value: surveys.filter((survey) => survey.status === status).length,
      })),
    [surveys],
  );

  const scoreTrend = useMemo(() => {
    let running = 0;
    return surveys
      .slice()
      .reverse()
      .slice(-24)
      .map((survey, index) => {
        running += survey.behaviourScore || 0;
        return { label: String(index + 1), score: running };
      });
  }, [surveys]);

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold text-gray-900">Analytics</h1>
      <div className="grid gap-6 xl:grid-cols-2">
        <BehaviourChart data={scoreTrend} />
        <WasteTypeChart data={statusData} />
      </div>
      <ScoreTrendChart data={scores.slice(0, 12).map((score) => ({ label: score.userId.slice(0, 6), value: score.totalScore }))} />
    </div>
  );
}
