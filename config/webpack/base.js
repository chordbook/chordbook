const { webpackConfig, merge } = require('@rails/webpacker')
const vueConfig = require('./rules/vue')
const cssConfig = require('./rules/css')

// FIXME: make this work with lastest webpacker
// const WebpackerPwa = require('webpacker-pwa')
// new WebpackerPwa(config, environment)

// Delete `node_modules` from excluded path so they get transpiled
// https://github.com/rails/webpacker/issues/1239
// webpackConfig.module.rules.forEach(rule => {
//   if (String(rule.exclude) === '/node_modules/') {
//     delete rule.exclude
//   }
// })

const config = merge(vueConfig, cssConfig, webpackConfig, {
  resolve: {
    alias: {
      'handlebars' : 'handlebars/dist/handlebars.js',
      'vue': 'vue/dist/vue.esm-bundler.js'
    }
  }
})

module.exports = config
