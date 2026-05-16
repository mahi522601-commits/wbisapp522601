import { useEffect, useState } from 'react';
import {
  collection,
  limit,
  onSnapshot,
  orderBy,
  query,
  QueryConstraint,
} from 'firebase/firestore';
import { db } from '../config/firebaseConfig';

export function useCollection<T>(
  collectionName: string,
  orderField?: string,
  max = 500,
) {
  const [data, setData] = useState<T[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const constraints: QueryConstraint[] = [limit(max)];
    if (orderField) constraints.unshift(orderBy(orderField, 'desc'));

    const q = query(collection(db, collectionName), ...constraints);
    return onSnapshot(
      q,
      (snap) => {
        setData(snap.docs.map((doc) => ({ id: doc.id, ...doc.data() }) as T));
        setLoading(false);
      },
      (err) => {
        setError(err.message);
        setLoading(false);
      },
    );
  }, [collectionName, max, orderField]);

  return { data, loading, error };
}
