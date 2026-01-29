const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  theme: {
    extend: {
      fontFamily: {
        sans: ["Rubik", "sans-serif"],
      },
      colors: {
        // Override Tailwind's default colors with our design system
        slate: {
          50: '#fafaf9',   // var(--slate-50)
          100: '#f6f5f3',  // var(--slate-100)
          200: '#e8e7e4',  // var(--slate-200)
          300: '#d3d2ce',  // var(--slate-300)
          400: '#a3a29f',  // var(--slate-400)
          500: '#716f68',  // var(--slate-500)
          600: '#5a5850',  // var(--slate-600)
          700: '#3f3e38',  // var(--slate-700)
          800: '#2a2924',  // var(--slate-800)
          900: '#1d1c19',  // var(--slate-900)
        },
        amber: {
          50: '#fefcf3',   // var(--amber-50)
          200: '#f5eddc',  // var(--amber-200)
          500: '#c9a227',  // var(--amber-500) / var(--oscar-gold)
          600: '#a68a1f',  // var(--amber-600)
          700: '#6d5600',  // var(--amber-700)
        },
        red: {
          50: '#F0E5E5',   // var(--red-50)
          200: '#d4a5a5',  // var(--red-200)
          600: '#560202',  // var(--red-600)
          700: '#3d0000',  // var(--red-700)
        },
        green: {
          50: '#EFF6F1',   // var(--green-50)
          500: '#025522',  // var(--green-500)
        },
        emerald: {
          500: '#025522',  // var(--emerald-500)
        },
        rose: {
          500: '#560202',  // var(--rose-500)
        },
      },
    },
  },
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js",
    "node_modules/preline/dist/*.js",
    "./app/components/**/*",
  ],
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    require("preline/plugin"),
  ],
};
