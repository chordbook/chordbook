import { createFetch } from '@vueuse/core'
import { computed, reactive, ref, unref } from 'vue'
import useAuthStore from '@/stores/auth'
import LinkHeader from 'http-link-header'

const BASE_URL = import.meta.env.APP_API_URL || 'https://api.chordbook.app/'

// Prefix URL with base and add query parameters
function buildUrl ({ url, options }) {
  // The existing useFetch implementation for baseUrl does naive string
  // concatenation instead of proper URL joining.
  const newUrl = new URL(url, BASE_URL)

  // Add support for query parameters to default useFetch implementation
  if (options?.params) {
    for (const [key, val] of new URLSearchParams(options.params)) {
      newUrl.searchParams.append(key, val)
    }
  }
  return { url: newUrl.toString() }
}

export const doFetch = createFetch({
  options: {
    beforeFetch (context) {
      Object.assign(context, buildUrl(context))
      Object.assign(context, useAuthStore().beforeFetch(context))
      return context
    }
  },
  fetchOptions: {
    headers: {
      'Content-Type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest'
    }
  }
})

export function useFetch (...args) {
  return useAuthStore().handleExpiredToken(doFetch(...args))
}

// A paginated data source
export function useDataSource () {
  const pages = ref([])
  const items = ref([])

  const lastPage = computed(() => pages.value.slice(-1)[0])
  const nextSrc = computed(() => {
    if (isDisabled.value) return

    const links = LinkHeader.parse(lastPage.value.response.headers.get('Link') ?? '')

    if (links.has('rel', 'next')) {
      return links.get('rel', 'next')[0].uri
    }

    return false
  })
  const isDisabled = computed(() => !lastPage.value || lastPage.value.isFetching)
  const isEmpty = computed(() => {
    const page = pages.value[0]
    return page?.isFinished && !page.error && items.value.length === 0
  })

  function load (src = nextSrc, params = {}) {
    const page = reactive(useFetch(unref(src), { params }).get().json())
    pages.value.push(page)
    page.onFetchResponse(({ data }) => items.value.push(...Array.from(data.value)))
    return page
  }

  return { items, pages, load, isDisabled, isEmpty }
}
