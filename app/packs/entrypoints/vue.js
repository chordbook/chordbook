import TurbolinksAdapter from 'vue-turbolinks'
import { createApp } from 'vue'
import store from '../store'
import Songsheet from '../components/songsheet'
import Chord from '../components/chord'
import Icon from '../components/icon'
import ChordDiagram from '../components/chord-diagram'
import Wakelock from '../components/wakelock'

document.addEventListener('turbolinks:load', () => {
  const app = createApp({})
  app.use(store)
  app.use(TurbolinksAdapter)
  app.component('icon', Icon)
  app.component('songsheet', Songsheet)
  app.component('chord', Chord)
  app.component('chord-diagram', ChordDiagram)
  app.component('wakelock', Wakelock)
  app.mount('[data-behavior=vue]')
})
