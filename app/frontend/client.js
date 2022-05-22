import axios from 'axios'
import { createFetch } from '@vueuse/core'
import useAuthStore from '@/stores/auth'

// DEPRECATED
export default axios.create({
  baseURL: import.meta.env.APP_API_URL || 'https://api.chordbook.app',
  withCredentials: true,
  headers: {
    'Content-Type': 'application/json',
    'X-Requested-With': 'XMLHttpRequest'
  }
})

export const useFetch = createFetch({
  baseUrl: new URL(import.meta.env.APP_API_URL || 'https://api.chordbook.app/', window.location).toString(),
  options: {
    beforeFetch ({ options }) {
      const auth = useAuthStore()

      if (auth.isAuthenticated) {
        options.credentials = 'include'
        options.headers = { ...options.headers, ...auth.headers }

        return { options }
      }
    }
  },
  fetchOptions: {
    headers: {
      'Content-Type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest'
    }
  }
})
