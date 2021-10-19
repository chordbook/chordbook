const { webpackConfig, merge } = require('@rails/webpacker')
const vueConfig = require('./rules/vue')
const cssConfig = require('./rules/css')

// FIXME: make this work with lastest webpacker
// const WebpackerPwa = require('webpacker-pwa')
// new WebpackerPwa(config, environment)

const config = merge(vueConfig, cssConfig, webpackConfig, {
  resolve: {
    fallback: {
      fs: false
    }
  }
})

module.exports = config
