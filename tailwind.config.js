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
        'primary-light': '#D1EEEE',
        teal: colors.teal,
        orange: {
          100: '#fffaf0',
          200: '#feebc8',
          300: '#fbd38d',
          400: '#f6ad55',
          500: '#ed8936',
          600: '#dd6b20',
          700: '#c05621',
          800: '#9c4221',
          900: '#7b341e',
        }
      },
    },
  },
  variants: {},
  plugins: [],
}
