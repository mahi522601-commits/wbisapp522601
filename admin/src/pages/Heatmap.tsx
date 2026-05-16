import React, { useMemo } from 'react';
import { MapPin } from 'lucide-react';
import { useCollection } from '../hooks/useFirestore';
import { Survey } from '../types/survey';

export default function Heatmap() {
  const { data: surveys } = useCollection<Survey>('surveys', 'createdAt');
  const points = useMemo(
    () =>
      surveys
        .filter((survey) => Number.isFinite(Number(survey.latitude)) && Number.isFinite(Number(survey.longitude)))
        .slice(0, 80),
    [surveys],
  );

  return (
    <div className="space-y-5">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">GIS Heatmap</h1>
        <p className="mt-1 text-sm text-gray-500">Survey locations rendered as a lightweight operational preview.</p>
      </div>
      <div className="relative h-[560px] overflow-hidden rounded-lg border border-gray-100 bg-white shadow-sm">
        <div className="absolute inset-0 bg-[linear-gradient(90deg,#e5e7eb_1px,transparent_1px),linear-gradient(#e5e7eb_1px,transparent_1px)] bg-[size:48px_48px]" />
        {points.map((point, index) => (
          <div
            key={point.id}
            title={`${point.wardName}, ${point.city}`}
            className={`absolute flex h-7 w-7 -translate-x-1/2 -translate-y-1/2 items-center justify-center rounded-full text-white shadow ${
              point.colorCode === 'GREEN'
                ? 'bg-green-600'
                : point.colorCode === 'YELLOW'
                  ? 'bg-yellow-500'
                  : point.colorCode === 'BLACK'
                    ? 'bg-neutral-800'
                    : 'bg-red-600'
            }`}
            style={{
              left: `${8 + ((Math.abs(Number(point.longitude)) * 13 + index * 7) % 84)}%`,
              top: `${8 + ((Math.abs(Number(point.latitude)) * 17 + index * 5) % 84)}%`,
            }}
          >
            <MapPin size={14} />
          </div>
        ))}
        <div className="absolute bottom-4 left-4 rounded-lg bg-white/95 p-3 text-sm shadow">
          <p className="font-bold text-gray-900">{points.length} mapped survey points</p>
          <p className="text-gray-500">Connect Google Maps or Mapbox for production GIS layers.</p>
        </div>
      </div>
    </div>
  );
}
