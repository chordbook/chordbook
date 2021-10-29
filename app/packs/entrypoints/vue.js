import { createApp } from 'vue'
import TurbolinksAdapter from 'vue-turbolinks'
import store from '~/store'

import Song from '~/components/song/index.vue'
import SongEditor from '~/components/editor.vue'
import Songsheet from '~/components/songsheet.vue'
import Chord from '~/components/chord.vue'
import ChordDiagram from '~/components/chord-diagram.vue'
import Tuner from '~/components/tuner.vue'
import AppHeader from '~/components/app-header.vue'

document.addEventListener('turbolinks:load', () => {
  const app = createApp({})
  app.use(store)
  app.use(TurbolinksAdapter)
  app.component('app-header', AppHeader)
  app.component('songsheet', Songsheet)
  app.component('song-editor', SongEditor)
  app.component('song', Song)
  app.component('chord', Chord)
  app.component('chord-diagram', ChordDiagram)
  app.component('tuner', Tuner)
  app.mount('[data-behavior=vue]')
})
