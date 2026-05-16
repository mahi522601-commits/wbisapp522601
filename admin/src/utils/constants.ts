export const COLLECTIONS = {
  users: 'users',
  surveys: 'surveys',
  reports: 'waste_reports',
  scores: 'behaviour_scores',
  workers: 'workers',
  analytics: 'analytics',
} as const;

export const STATUS_LABELS: Record<string, string> = {
  proper: 'Proper',
  minorMixing: 'Minor Mixing',
  mixedWaste: 'Mixed Waste',
  hazardous: 'Hazardous',
};

export const STATUS_COLORS: Record<string, string> = {
  GREEN: 'bg-green-100 text-green-800 border-green-200',
  YELLOW: 'bg-yellow-100 text-yellow-800 border-yellow-200',
  RED: 'bg-red-100 text-red-800 border-red-200',
  BLACK: 'bg-neutral-800 text-white border-neutral-800',
};
