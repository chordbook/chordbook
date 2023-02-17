module.exports = {
  content: [
    './client/**/*.html',
    './client/**/*.js',
    './client/**/*.vue'
  ],
  theme: {
    screens: {
      xs: '0px',
      sm: '576px',
      md: '768px',
      lg: '992px',
      xl: '1200px'
    },
    extend: {
      aspectRatio: {
        '4/3': '4 / 3',
        '16/9': '16 / 9'
      },
      minHeight: {
        full: '100%',
        'screen-1/4': '25vh',
        'screen-1/2': '50vh',
        'screen-2/3': '66vh',
        'screen-3/4': '75vh'
      },
      maxHeight: {
        'screen-1/2': '50vh',
        'screen-2/3': '66vh'
      },
      gridAutoColumns: {
        '1/1': '92.5%',
        '1/2': '46.25%',
        '1/3': '31.66%',
        '1/4': '23.75%',
        '1/5': '19%',
        '1/6': '15.833%',
        '1/8': '11.875%'
      },
      fontSize: {
        bigger: '1.1em',
        smaller: '0.75em'
      }
    }
  },
  plugins: [
    require('@tailwindcss/line-clamp')
  ]
}
