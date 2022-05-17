module.exports = {
  plugins: [
    require('tailwindcss')('./app/frontend/tailwind.config.js'),
    require('postcss-import'),
    require('autoprefixer')
  ]
}
