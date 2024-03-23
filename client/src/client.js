import { createFetch } from '@vueuse/core'
import { computed, unref, watch } from 'vue'
import useAuthStore from '@/stores/auth'

const BASE_URL = import.meta.env.APP_API_URL || 'https://api.chordbook.app/'

// Prefix URL with base and add query parameters
function buildUrl (url, params) {
  return computed(() => {
    // The existing useFetch implementation for baseUrl does naive string
    // concatenation instead of proper URL joining.
    const newUrl = new URL(unref(url), BASE_URL)

    // Add support for query parameters to default useFetch implementation
    if (params) {
      for (const [key, val] of new URLSearchParams(unref(params))) {
        newUrl.searchParams.append(key, val)
      }
    }

    return newUrl.toString()
  })
}

export const doFetch = createFetch({
  options: {
    beforeFetch (context) {
      return useAuthStore().beforeFetch(context)
    }
  },
  fetchOptions: {
    headers: {
      'Content-Type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest'
    }
  }
})

export function useFetch (url, options = {}, ...args) {
  const fullUrl = buildUrl(url, options.params)
  const fetch = doFetch(fullUrl, options, ...args)

  // Check for expired token on errors, which will refresh the token and re-execute
  fetch.onFetchError(() => useAuthStore().handleExpiredToken(fetch))

  return fetch
}
