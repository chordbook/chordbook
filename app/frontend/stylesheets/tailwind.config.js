module.exports = {
  content: [
    './**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/frontend/**/*.js',
    './app/frontend/**/*.vue'
  ],
  theme: {
    container: (theme) => ({
      center: true,
      padding: theme('spacing.4')
    })
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('tailwindcss-multi-column')()
  ]
}
