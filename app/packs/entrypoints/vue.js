import TurbolinksAdapter from 'vue-turbolinks'
import { createApp } from 'vue'
import store from '~/store'
import Songsheet from '~/components/songsheet/index.vue'
import Chord from '~/components/chord.vue'
import Icon from '~/components/icon.vue'
import ChordDiagram from '~/components/chord-diagram.vue'
import Tuner from '~/components/tuner.vue'

document.addEventListener('turbolinks:load', () => {
  const app = createApp({})
  app.use(store)
  app.use(TurbolinksAdapter)
  app.component('icon', Icon)
  app.component('songsheet', Songsheet)
  app.component('chord', Chord)
  app.component('chord-diagram', ChordDiagram)
  app.component('tuner', Tuner)
  app.mount('[data-behavior=vue]')
})
