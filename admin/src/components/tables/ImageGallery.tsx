import React, { useState } from 'react';
import ImageViewer from '../ui/ImageViewer';

export default function ImageGallery({ urls }: { urls: string[] }) {
  const [selected, setSelected] = useState<string | null>(null);
  if (!urls.length) return <p className="text-sm text-gray-500">No images available.</p>;

  return (
    <>
      <div className="grid grid-cols-2 gap-3 md:grid-cols-4">
        {urls.map((url) => (
          <button key={url} type="button" onClick={() => setSelected(url)} className="overflow-hidden rounded-lg border border-gray-100">
            <img src={url} alt="Waste evidence" className="h-28 w-full object-cover" />
          </button>
        ))}
      </div>
      {selected && <ImageViewer url={selected} onClose={() => setSelected(null)} />}
    </>
  );
}
