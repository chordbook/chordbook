import { createFetch } from '@vueuse/core'
import { computed, reactive, unref, watch } from 'vue'
import useAuthStore from '@/stores/auth'
import LinkHeader from 'http-link-header'

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

export function useFetch (url, options = {}) {
  const fullUrl = buildUrl(url, options.params)
  const fetch = useAuthStore().handleExpiredToken(doFetch(fullUrl, options))

  // Abort previous fetch when url changes if refetch is enabled
  watch(fullUrl, () => unref(options.refetch) && fetch.abort())

  return fetch
}

// A paginated data source
export function useDataSource () {
  const pages = reactive([])
  const items = reactive([])

  const lastPage = computed(() => pages.slice(-1)[0])
  const nextSrc = computed(() => {
    if (isDisabled.value) return

    const links = LinkHeader.parse(lastPage.value.response.headers.get('Link') ?? '')

    if (links.has('rel', 'next')) {
      return links.get('rel', 'next')[0].uri
    }

    return false
  })
  const isDisabled = computed(() => !lastPage.value || lastPage.value.isFetching)
  const isFetching = computed(() => pages.some(page => page.isFetching))
  const isEmpty = computed(() => {
    const page = pages[0]
    return page?.isFinished && !page.error && page.data.length === 0
  })

  function load (src = nextSrc.value, options = {}) {
    const page = useFetch(src, {
      ...options,
      afterFetch (page) {
        items.push(...Array.from(page.data))

        pages.indexOf()
      }
    }).get().json()

    pages.push(page)
    return page
  }

  return { items, pages, load, isFetching, isDisabled, isEmpty }
}
