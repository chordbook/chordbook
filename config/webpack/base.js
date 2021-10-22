const { webpackConfig, merge } = require('@rails/webpacker')
const vue = require('./rules/vue')
const css = require('./rules/css')
const icons = require('./rules/icons')
const aliases = require('./rules/aliases')

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

const config = merge(vue, css, icons, aliases, webpackConfig)

module.exports = config
