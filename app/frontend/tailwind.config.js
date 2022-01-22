module.exports = {
  content: [
    './app/frontend/**/*.html',
    './app/frontend/**/*.js',
    './app/frontend/**/*.vue'
  ],
  theme: {
    container: (theme) => ({
      center: true,
      padding: theme('spacing.4')
    }),
    minHeight: {
      full: '100%',
      'screen-1/4': '25vh',
      'screen-1/2': '50vh',
      'screen-2/3': '66vh',
      'screen-3/4': '75vh'
    }
  },
  plugins: [
    require('@tailwindcss/line-clamp'),
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography')
  ]
}
