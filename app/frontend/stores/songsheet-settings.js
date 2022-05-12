import { defineStore } from 'pinia'
import { useStorage } from '@vueuse/core'

export default defineStore('SongsheetSettings', {
  state: () => ({
    instrument: useStorage('instrument', 'guitar'),
    showChords: useStorage('showChords', false),
    columns: useStorage('columns', 1),

    // Avoid persisting for now
    transpose: 0
  })
})
