import { Timestamp } from 'firebase/firestore';

export type WasteStatus = 'proper' | 'minorMixing' | 'mixedWaste' | 'hazardous';
export type WasteColorCode = 'GREEN' | 'YELLOW' | 'RED' | 'BLACK';

export interface Survey {
  id: string;
  userId: string;
  householdId: string;
  wardName: string;
  city: string;
  status: WasteStatus;
  colorCode: WasteColorCode;
  behaviourScore: number;
  latitude: number;
  longitude: number;
  photoUrl?: string;
  workerNotes?: string;
  isValidated: boolean;
  validatedBy?: string;
  validatedAt?: Timestamp;
  createdAt?: Timestamp;
  metadata?: Record<string, unknown>;
}
