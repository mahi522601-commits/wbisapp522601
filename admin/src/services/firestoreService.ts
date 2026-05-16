import {
  DocumentData,
  addDoc,
  collection,
  deleteDoc,
  doc,
  getDocs,
  orderBy,
  query,
  updateDoc,
} from 'firebase/firestore';
import { db } from '../config/firebaseConfig';

export class FirestoreService {
  static async list<T>(collectionName: string, orderField = 'createdAt'): Promise<T[]> {
    const snap = await getDocs(
      query(collection(db, collectionName), orderBy(orderField, 'desc')),
    );
    return snap.docs.map((item) => ({ id: item.id, ...item.data() }) as T);
  }

  static async add(collectionName: string, data: DocumentData) {
    return addDoc(collection(db, collectionName), data);
  }

  static async update(collectionName: string, id: string, data: DocumentData) {
    return updateDoc(doc(db, collectionName, id), data);
  }

  static async remove(collectionName: string, id: string) {
    return deleteDoc(doc(db, collectionName, id));
  }
}
