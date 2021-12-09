import { createWebHistory, createRouter } from 'vue-router'

import Index from '~/views/Index.vue'
import SongShow from '~/views/songs/Show.vue'
import SongEditor from '~/views/songs/Editor.vue'
import Tuner from '~/views/Tuner.vue'

const routes = [
  { path: '/', component: Index },
  { path: '/tuner', component: Tuner },
  { path: '/songs/new', component: SongEditor },
  { path: '/songs/:id', component: SongShow, name: 'song' },
  { path: '/songs/:id/edit', component: SongEditor, name: 'song.edit', props: true }
]

export default createRouter({
  history: createWebHistory(),
  routes
})
