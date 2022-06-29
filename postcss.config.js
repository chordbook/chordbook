module.exports = {
  plugins: [
    require('tailwindcss')('./client/tailwind.config.js'),
    require('postcss-import'),
    require('autoprefixer')
  ]
}
