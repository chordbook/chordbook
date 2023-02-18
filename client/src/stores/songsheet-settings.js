import { defineStore } from 'pinia'
import { useStorage } from '@vueuse/core'

export default defineStore('SongsheetSettings', {
  state: () => ({
    instrument: useStorage('instrument', 'guitar'),
    showChords: useStorage('showChords', false),
    columns: useStorage('columns', 1),
    showPlayer: useStorage('showPlayer', true),

    // Avoid persisting for now
    transpose: 0
  }),

  actions: {
    resetTranspose() {
      this.transpose = 0
    }
  }
})
