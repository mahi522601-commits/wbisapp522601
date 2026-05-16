import React from 'react';

const tones: Record<string, string> = {
  green: 'bg-green-100 text-green-800 border-green-200',
  yellow: 'bg-yellow-100 text-yellow-800 border-yellow-200',
  red: 'bg-red-100 text-red-800 border-red-200',
  blue: 'bg-blue-100 text-blue-800 border-blue-200',
  gray: 'bg-gray-100 text-gray-700 border-gray-200',
  dark: 'bg-neutral-800 text-white border-neutral-800',
};

export default function Badge({
  children,
  tone = 'gray',
}: {
  children: React.ReactNode;
  tone?: keyof typeof tones;
}) {
  return (
    <span className={`inline-flex items-center rounded-full border px-2 py-1 text-xs font-semibold ${tones[tone]}`}>
      {children}
    </span>
  );
}
