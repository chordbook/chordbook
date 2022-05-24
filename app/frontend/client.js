import axios from 'axios'
import { createFetch } from '@vueuse/core'
import { computed, unref } from 'vue'
import useAuthStore from '@/stores/auth'

export const doFetch = createFetch({
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

export const useFetch = (url, options = {}, ...args) => {
  // Add support for query parameters to default useFetch implementation
  if (options?.params) {
    const params = options.params
    delete options.params
    const newUrl = computed(() => unref(url) + '?' + new URLSearchParams(unref(params)))
    return doFetch(newUrl, options, ...args)
  }

  return doFetch(url, options, ...args)
}

// DEPRECATED
const client = axios.create({
  baseURL: import.meta.env.APP_API_URL || 'https://api.chordbook.app',
  headers: {
    'Content-Type': 'application/json',
    'X-Requested-With': 'XMLHttpRequest'
  }
})

client.interceptors.request.use(config => {
  const auth = useAuthStore()

  if (auth.isAuthenticated) {
    config.withCredentials = true
    config.headers = { ...config.headers, ...auth.headers }
  }

  return config
})

export default client
