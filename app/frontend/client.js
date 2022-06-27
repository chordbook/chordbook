import axios from 'axios'
import { createFetch } from '@vueuse/core'
import { computed, unref } from 'vue'
import useAuthStore from '@/stores/auth'

export const doFetch = createFetch({
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
  const fullUrl = computed(() => {
    // Join url with base url
    const newUrl = new URL(unref(url), import.meta.env.APP_API_URL || 'https://api.chordbook.app/')

    // Add support for query parameters to default useFetch implementation
    if (options?.params) {
      for (const [key, val] of new URLSearchParams(options.params)) {
        newUrl.searchParams.append(key, val)
      }
    }

    return newUrl.toString()
  })

  return doFetch(fullUrl, options, ...args)
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
