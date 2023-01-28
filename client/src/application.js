import './application.css'

import { createApp } from 'vue'
import { createHead } from '@vueuse/head'
import { createPinia } from 'pinia'
import { IonicVue } from '@ionic/vue'
import App from './views/App.vue'
import router from './router'
import telemetry from './telemetry'
import * as components from './components'
import ionicConfig from './config'
import useSentry from './sentry'

const app = createApp(App)
  .use(createHead({ titleTemplate: '%s - Chord Book' }))
  .use(createPinia())
  .use(IonicVue, ionicConfig)
  .use(router)

for (const name in components) {
  app.component(name, components[name])
}

useSentry(app, router)

router.isReady().then(() => {
  telemetry()
  app.mount('[data-behavior=vue]')
})
