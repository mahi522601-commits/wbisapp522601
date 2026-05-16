import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';
import { getStorage } from 'firebase/storage';

const env = import.meta.env;

const firebaseConfig = {
  apiKey: env.VITE_FIREBASE_API_KEY || env.REACT_APP_FIREBASE_API_KEY || '',
  authDomain: env.VITE_FIREBASE_AUTH_DOMAIN || 'wbis-ba283.firebaseapp.com',
  projectId: env.VITE_FIREBASE_PROJECT_ID || 'wbis-ba283',
  storageBucket: env.VITE_FIREBASE_STORAGE_BUCKET || 'wbis-ba283.firebasestorage.app',
  messagingSenderId: env.VITE_FIREBASE_MESSAGING_SENDER_ID || '720453653584',
  appId: env.VITE_FIREBASE_APP_ID || '1:720453653584:android:c98d9010b1aad9cfc26d55',
};

const app = initializeApp(firebaseConfig);

export const auth = getAuth(app);
export const db = getFirestore(app);
export const storage = getStorage(app);
export default app;
