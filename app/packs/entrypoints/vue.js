import { createApp } from 'vue'
import TurbolinksAdapter from 'vue-turbolinks'
import store from '~/store'

const components = import.meta.globEager('../components/*.vue')

document.addEventListener('turbolinks:load', () => {
  const app = createApp({})
  app.use(store)
  app.use(TurbolinksAdapter)

  Object.entries(components).forEach(([path, definition]) => {
    const componentName = path.split('/').pop().replace(/\.vue$/, '')
    app.component(componentName, definition.default)
  })

  app.mount('[data-behavior=vue]')
})
