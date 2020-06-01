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
        brand: {
          red: "#ff5c5c",
          pink: "#ee7abb",
          turquoise: "#22cae1",
          yellow: "#ffe8b4",
          green: "#09ca77",
          navy: "#0a0039",
          "navy-5": "rgba(10, 0, 57, 0.05)",
          "navy-10": "rgba(10, 0, 5, 0.1)",
          "navy-75": "rgba(10, 0, 5, 0.75)",
        },
        phase: {
          alpha: "#d7288e",
          beta: "#c25400",
          discovery: "#0c9def",
          idea: "rgba(12, 157, 239, 0.25)",
          live: "#019b59",
          scoping: "rgba(12, 157, 239, 0.5)",
        },
      },
    },
  },
};
