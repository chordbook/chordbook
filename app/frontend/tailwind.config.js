module.exports = {
  content: [
    './app/frontend/**/*.html',
    './app/frontend/**/*.js',
    './app/frontend/**/*.vue'
  ],
  theme: {
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
        '1/1': '95%',
        '1/2': '47.5%',
        '1/3': '31.66%',
        '1/4': '23.75%',
        '1/5': '19%',
        '1/6': '15.833%'
      }
    }
  },
  plugins: [
    require('@tailwindcss/line-clamp')
  ]
}
