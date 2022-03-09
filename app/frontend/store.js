import { defineStore } from 'pinia'
import { useStorage } from '@vueuse/core'

export const useStore = defineStore({
  id: 'store',

  state: () => useStorage('store', {}),

  actions: {
    update (newState) {
      Object.assign(this.$state, newState)
    }
  }
})
