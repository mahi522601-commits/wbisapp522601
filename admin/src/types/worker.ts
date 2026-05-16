import { Timestamp } from 'firebase/firestore';

export interface Worker {
  id: string;
  userId: string;
  name: string;
  wardAssigned: string;
  routeCompleted: number;
  missedHouseholds: number;
  reportingAccuracy: number;
  lastActive?: Timestamp;
}
