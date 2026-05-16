import { getDownloadURL, ref, uploadBytesResumable } from 'firebase/storage';
import { storage } from '../config/firebaseConfig';

export class StorageService {
  static uploadImage(path: string, file: File, onProgress?: (progress: number) => void) {
    const task = uploadBytesResumable(ref(storage, path), file, {
      contentType: file.type,
    });

    return new Promise<string>((resolve, reject) => {
      task.on(
        'state_changed',
        (snapshot) => {
          if (snapshot.totalBytes) {
            onProgress?.(snapshot.bytesTransferred / snapshot.totalBytes);
          }
        },
        reject,
        async () => resolve(await getDownloadURL(task.snapshot.ref)),
      );
    });
  }
}
