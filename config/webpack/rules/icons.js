const SVGSpritemapPlugin = require('svg-spritemap-webpack-plugin')
const path = require('path')

const root = path.resolve(__dirname, '../../..')
const manifest = require(path.resolve(root, 'app/icons'))

// Resolve manifest to glob patterns
const icons = Object.entries(manifest).flatMap(([directory, patterns]) => {
  return Array.from(patterns).map(pattern => {
    return path.resolve(root, directory, `${pattern}.svg`)
  })
})

module.exports = {
  plugins: [
    new SVGSpritemapPlugin(icons, {})
  ]
}
