/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{ts,tsx}'],
  theme: {
    extend: {
      colors: {
        wbis: {
          green: '#1B5E20',
          accent: '#4CAF50',
          surface: '#F6F8F6',
          ink: '#172018'
        }
      }
    }
  },
  plugins: []
};
