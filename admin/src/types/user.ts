import { Timestamp } from 'firebase/firestore';

export type UserRole = 'citizen' | 'worker' | 'admin';

export interface WBISUser {
  id: string;
  uid: string;
  email: string;
  displayName: string;
  phone?: string;
  role: UserRole;
  wardName?: string;
  city?: string;
  householdId?: string;
  photoUrl?: string;
  createdAt?: Timestamp;
}
