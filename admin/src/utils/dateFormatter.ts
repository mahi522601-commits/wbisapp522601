import { format } from 'date-fns';

export function toDate(value: any): Date | null {
  if (!value) return null;
  if (value instanceof Date) return value;
  if (typeof value.toDate === 'function') return value.toDate();
  if (typeof value === 'string') {
    const parsed = new Date(value);
    return Number.isNaN(parsed.getTime()) ? null : parsed;
  }
  return null;
}

export function formatDate(value: any, pattern = 'dd MMM yyyy'): string {
  const date = toDate(value);
  return date ? format(date, pattern) : '-';
}
