import { Timestamp } from 'firebase/firestore';

export interface BehaviourScore {
  id: string;
  userId: string;
  totalScore: number;
  surveyCount: number;
  ecoPoints: number;
  lastUpdated?: Timestamp;
}
