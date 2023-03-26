module.exports = {
  purge: ['./src/**/*.{js,jsx,ts,tsx}', './public/index.html'],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      borderRadius: {
        '3xl': '5rem',
      },
      screen: {
        'round': '20rem',
        '3xl': '5rem'
      },
      colors: {
        'regal-blue': '#0F3D3E',
        'primary': '#5680E9',
        'new': '#0F3D3E',
        'new-secondary': '#F1F1F1',
        'secondary': {
          1: '#84CEEB',
          2: '#100F0F',
          3: '#E2DCC8',
          4: '#F1F1F1',
        },
        'tertiary': '#F1F1F1',
        'button-col': '#E2DCC8',
        'buyer-background': '#F1F1F1',
        'table-header': '#E2DCC8',
        'table-data': '#F1F1F1'
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
}