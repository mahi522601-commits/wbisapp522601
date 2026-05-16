import {
  QueryConstraint,
  Timestamp,
  collection,
  getDocs,
  orderBy,
  query,
  where,
} from 'firebase/firestore';
import { db } from '../config/firebaseConfig';

export type ExportFormat = 'csv' | 'json' | 'excel';

export interface ExportOptions {
  collection: string;
  format: ExportFormat;
  filters?: Record<string, unknown>;
  dateRange?: { from: Date; to: Date };
  columns?: string[];
  includeImages?: boolean;
  filename?: string;
}

export class ExportService {
  static async exportData(options: ExportOptions): Promise<void> {
    const constraints: QueryConstraint[] = [orderBy('createdAt', 'desc')];

    if (options.dateRange) {
      constraints.push(
        where('createdAt', '>=', Timestamp.fromDate(options.dateRange.from)),
        where('createdAt', '<=', Timestamp.fromDate(options.dateRange.to)),
      );
    }

    if (options.filters) {
      Object.entries(options.filters).forEach(([key, value]) => {
        if (value !== undefined && value !== null && value !== 'all') {
          constraints.push(where(key, '==', value));
        }
      });
    }

    const snap = await getDocs(query(collection(db, options.collection), ...constraints));
    const rawData = snap.docs.map((docSnap) => ({ id: docSnap.id, ...docSnap.data() }));
    const data = this.formatData(rawData, options.columns);
    const filename = options.filename || `wbis_${options.collection}_${Date.now()}`;

    switch (options.format) {
      case 'csv':
        return this.downloadCSV(data, filename);
      case 'json':
        return this.downloadJSON(data, filename);
      case 'excel':
        return this.downloadExcel(data, filename);
    }
  }

  private static formatData(data: any[], columns?: string[]): Record<string, unknown>[] {
    return data.map((row) => {
      const formatted: Record<string, unknown> = {};
      const keys = columns?.length ? columns : Object.keys(row);
      keys.forEach((key) => {
        const value = row[key];
        if (value?.toDate) formatted[key] = value.toDate().toLocaleString('en-IN');
        else if (typeof value === 'object' && value !== null) formatted[key] = JSON.stringify(value);
        else formatted[key] = value ?? '';
      });
      return formatted;
    });
  }

  private static downloadCSV(data: Record<string, unknown>[], filename: string): void {
    if (!data.length) return;
    const headers = Object.keys(data[0]);
    const csvRows = [
      headers.join(','),
      ...data.map((row) =>
        headers
          .map((header) => `"${String(row[header] ?? '').replace(/"/g, '""')}"`)
          .join(','),
      ),
    ];
    this.triggerDownload(
      new Blob([csvRows.join('\n')], { type: 'text/csv;charset=utf-8;' }),
      `${filename}.csv`,
    );
  }

  private static downloadJSON(data: unknown[], filename: string): void {
    this.triggerDownload(
      new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' }),
      `${filename}.json`,
    );
  }

  private static async downloadExcel(data: Record<string, unknown>[], filename: string) {
    const XLSX = await import('xlsx');
    const ws = XLSX.utils.json_to_sheet(data);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'WBIS Data');
    XLSX.writeFile(wb, `${filename}.xlsx`);
  }

  private static triggerDownload(blob: Blob, filename: string): void {
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = filename;
    link.click();
    URL.revokeObjectURL(url);
  }
}
