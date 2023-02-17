import { ref, reactive, computed } from 'vue'
import { useFetch } from '@/client'
import LinkHeader from 'http-link-header'

export default function usePaginatedFetch (url, fetchOptions = {}) {
  const nextUrl = ref(url)
  const pages = reactive([])
  const items = reactive([])
  const isFetching = computed(() => pages.some(page => page.isFetching))
  const isEmpty = computed(() => {
    const page = pages[0]
    return page?.isFinished && !page.error && page.data.length === 0
  })
  const isPaginating = computed(() => !!nextUrl.value)

  // Load the next page
  function load (reload = false) {
    if (nextUrl.value === null) return

    const page = useFetch(nextUrl.value, {
      ...fetchOptions,
      immediate: false
    }).get().json()

    page.onFetchResponse(() => {
      if (reload) {
        // Clear previous accumulator of items
        items.splice(0)

        // Clear previous pages
        pages.splice(-1)
      }

      items.push(...Array.from(page.data.value))

      const links = LinkHeader.parse(page.response.value.headers.get('Link') ?? '')
      if (links.has('rel', 'next')) {
        nextUrl.value = links.get('rel', 'next')[0].uri
      } else {
        nextUrl.value = null
      }
      // emit('load', page)
    })

    pages.push(page)

    if (fetchOptions.immediate !== false) {
      page.execute(true /* throw error */)
    }

    return page
  }

  function reload (event = null) {
    nextUrl.value = url
    return load(true) // reload
  }

  return { load, reload, items, pages, isFetching, isEmpty, isPaginating }
}
