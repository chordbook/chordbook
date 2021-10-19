module.exports = {
  // Purge unused TailwindCSS styles
  purge: {
    enabled: ['production'].includes(process.env.NODE_ENV),
    content: [
      './**/*.html.erb',
      './app/helpers/**/*.rb',
      './app/javascript/**/*.js'
    ]
  },
  darkMode: 'media', // or 'media' or 'class'
  theme: {
    container: (theme) => ({
      center: true,
      padding: theme('spacing.4')
    })
  },
  variants: {
    extend: {}
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('tailwindcss-multi-column')()
  ]
}
