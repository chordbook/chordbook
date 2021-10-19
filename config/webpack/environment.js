const { config, environment } = require('@rails/webpacker')
const { DefinePlugin } = require('webpack')
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')

const WebpackerPwa = require('webpacker-pwa')
new WebpackerPwa(config, environment)

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.plugins.prepend('Define', new DefinePlugin({
  __VUE_OPTIONS_API__: true,
  __VUE_PROD_DEVTOOLS__: false
}))

environment.loaders.prepend('vue', vue)
module.exports = environment
