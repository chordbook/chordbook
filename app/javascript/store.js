import { createStore } from 'vuex'

const localStoragePlugin = (store) => {
  // Persist state
  store.subscribe((_, state) => {
    localStorage.setItem('store', JSON.stringify(state))
  })

  // Restore state
  if (localStorage.getItem('store')) {
    const newState = JSON.parse(localStorage.getItem('store'))
    store.replaceState(Object.assign(store.state, newState))
  }
}

export const store = createStore({
  state () {
    return {}
  },

  mutations: {
    update (state, newState) {
      Object.assign(state, newState)
    }
  },

  plugins: [localStoragePlugin]
})

export default store
