import { Timestamp } from 'firebase/firestore';

export type ReportStatus = 'submitted' | 'underReview' | 'resolved' | 'rejected';
export type WasteCategory = 'dry' | 'wet' | 'sanitary' | 'hazardous' | 'mixed' | 'unknown';

export interface WasteReport {
  id: string;
  userId: string;
  category: WasteCategory;
  status: ReportStatus;
  description: string;
  city: string;
  wardName: string;
  latitude: number;
  longitude: number;
  photoUrl?: string;
  createdAt?: Timestamp;
  resolvedAt?: Timestamp;
}
