const defaultTheme = require('tailwindcss/defaultTheme')
const colors = require('tailwindcss/colors')

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
    extend: {
      colors: {
        primary: '#1BACAC',
        teal: colors.teal
      },
    },
  },
  variants: {},
  plugins: [],
}
