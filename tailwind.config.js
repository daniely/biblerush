const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  purge: [],
  theme: {
    fontFamily: {
      'sans': [
        'Open Sans',
        ...defaultTheme.fontFamily.sans,
      ],
      'serif': [defaultTheme.fontFamily.serif]
    },
    extend: {},
  },
  variants: {},
  plugins: [],
}
