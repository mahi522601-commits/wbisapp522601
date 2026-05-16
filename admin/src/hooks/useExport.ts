import { useState } from 'react';
import toast from 'react-hot-toast';
import { ExportOptions, ExportService } from '../services/exportService';

export function useExport() {
  const [isExporting, setIsExporting] = useState(false);

  async function exportData(options: ExportOptions) {
    setIsExporting(true);
    try {
      await ExportService.exportData(options);
      toast.success('Export ready');
    } catch (error: any) {
      toast.error(error?.message || 'Export failed');
    } finally {
      setIsExporting(false);
    }
  }

  return { exportData, isExporting };
}
