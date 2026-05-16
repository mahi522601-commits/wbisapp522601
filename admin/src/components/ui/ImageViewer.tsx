import React, { useEffect, useState } from 'react';
import { getDownloadURL, ref } from 'firebase/storage';
import { X } from 'lucide-react';
import { storage } from '../../config/firebaseConfig';

export default function ImageViewer({
  url,
  onClose,
}: {
  url: string;
  onClose: () => void;
}) {
  const [imageUrl, setImageUrl] = useState<string | null>(null);
  const [loadError, setLoadError] = useState<string | null>(null);

  useEffect(() => {
    let active = true;

    async function resolveImageUrl() {
      const trimmedUrl = url.trim();
      setImageUrl(null);
      setLoadError(null);

      if (!trimmedUrl) {
        setLoadError('No image URL was saved for this record.');
        return;
      }

      if (/^(https?:|data:|blob:)/i.test(trimmedUrl)) {
        setImageUrl(trimmedUrl);
        return;
      }

      try {
        const storagePath = trimmedUrl.startsWith('/') ? trimmedUrl.slice(1) : trimmedUrl;
        const downloadUrl = await getDownloadURL(ref(storage, storagePath));
        if (active) setImageUrl(downloadUrl);
      } catch (error: any) {
        if (active) {
          setLoadError(error?.message || 'Unable to load this image from storage.');
        }
      }
    }

    resolveImageUrl();

    return () => {
      active = false;
    };
  }, [url]);

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/70 p-4">
      <div className="relative max-h-[92vh] w-full max-w-4xl overflow-hidden rounded-lg bg-white">
        <button
          type="button"
          onClick={onClose}
          title="Close image"
          className="absolute right-3 top-3 rounded-full bg-white/90 p-2 text-gray-700 shadow hover:bg-white"
        >
          <X size={18} />
        </button>
        {loadError ? (
          <div className="flex min-h-[18rem] items-center justify-center px-6 py-12 text-center">
            <div>
              <p className="text-sm font-semibold text-gray-900">Image could not be displayed</p>
              <p className="mt-2 text-sm text-gray-500">{loadError}</p>
            </div>
          </div>
        ) : imageUrl ? (
          <img
            src={imageUrl}
            alt="Waste evidence"
            className="max-h-[92vh] w-full object-contain"
            onError={() => setLoadError('The saved image link is not accessible from the admin app.')}
          />
        ) : (
          <div className="flex min-h-[18rem] items-center justify-center px-6 py-12 text-sm font-semibold text-gray-500">
            Loading image...
          </div>
        )}
      </div>
    </div>
  );
}
