const { config, environment } = require('@rails/webpacker');
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')

const WebpackerPwa = require('webpacker-pwa')
new WebpackerPwa(config, environment)

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)
module.exports = environment
