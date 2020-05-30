module.exports = {
  purge: [
    "./app/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/javascript/**/*.vue",
    "./app/javascript/**/*.jsx",
  ],
  theme: {
    fontFamily: {
      sans: [
        "Inter",
        "-apple-system",
        "BlinkMacSystemFont",
        "Helvetica Neue",
        "Helvetica",
        "Arial",
        "sans-serif",
      ],
      lexenddeca: [
        "Lexend Deca",
        "-apple-system",
        "BlinkMacSystemFont",
        "Helvetica Neue",
        "Helvetica",
        "Arial",
        "sans-serif",
      ],
    },
    extend: {
      colors: {
        "brand-green": "#09CA77",
        "brand-navy": "#0a0039",
        "brand-navy-5": "#f2f2f5",
        "brand-pink": "#ee7abb",
        "brand-red": "#ff5c5c",
        "brand-turquoise": "#22cae1",
        "brand-yellow": "#ffe8b4",
        alpha: "#d7288e",
      },
    },
  },
};
