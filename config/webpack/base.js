const { webpackConfig, merge } = require('@rails/webpacker')
const vueConfig = require('./rules/vue')

// FIXME: make this work with lastest webpacker
// const WebpackerPwa = require('webpacker-pwa')
// new WebpackerPwa(config, environment)

module.exports = merge(vueConfig, webpackConfig)
