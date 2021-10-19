import TurbolinksAdapter from 'vue-turbolinks'
import { createApp } from 'vue/dist/vue.esm-bundler'
import Songsheet from '../components/songsheet'
import Chord from '../components/chord'
import ChordDiagram from '../components/chord-diagram'

document.addEventListener('turbolinks:load', () => {
  const app = createApp({})
  app.use(TurbolinksAdapter)
  app.component('songsheet', Songsheet)
  app.component('chord', Chord)
  app.component('chord-diagram', ChordDiagram)
  app.mount('[data-behavior=vue]')
})
