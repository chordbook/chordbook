import { createFetch } from '@vueuse/core'
import { computed, reactive, ref, unref } from 'vue'
import useAuthStore from '@/stores/auth'
import LinkHeader from 'http-link-header'

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

// A paginated data source
export function useDataSource (initialSrc, initialParams = {}) {
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
    page.then(({ data }) => items.value.push(...Array.from(data.value)))
    return page
  }

  load(initialSrc, initialParams)

  return { items, pages, load, isDisabled, isEmpty }
}
