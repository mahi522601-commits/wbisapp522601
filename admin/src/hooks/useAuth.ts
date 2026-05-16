import { useEffect, useMemo, useState } from 'react';
import {
  User,
  onAuthStateChanged,
  signInWithEmailAndPassword,
  signOut as firebaseSignOut,
} from 'firebase/auth';
import { auth } from '../config/firebaseConfig';

export function useAuth() {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    return onAuthStateChanged(auth, (nextUser) => {
      setUser(nextUser);
      setLoading(false);
    });
  }, []);

  return useMemo(
    () => ({
      user,
      loading,
      signIn: (email: string, password: string) =>
        signInWithEmailAndPassword(auth, email, password),
      signOut: () => firebaseSignOut(auth),
    }),
    [loading, user],
  );
}
