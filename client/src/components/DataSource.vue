<!--

A component that loads data from the API with automatic pagination.

Load one page of data:

  <data-source src="/thing/1" v-slot="{ data }">
    {{ data?.name }}
  </data-source>

Load a paginated list of items:

  <data-source src="/things" v-slot="{ items }">
    <div v-for="thing in items"></div>
  </data-source>

Or explicitly render each page

  <data-source src="/things">
    <template #page="{ data, isFetching, error }">
      <div v-for="thing in data"></div>
    </template>
  </data-source>

Empty placeholer:

  <data-source src="/things" v-slot="{ items }">
    <template #empty>No Items to display</template>
    <template #default="{ items }">…</template>
  </data-source>
-->
<script setup>
import { ref, reactive, computed, watch } from 'vue'
import { useFetch } from '@/client'
import LinkHeader from 'http-link-header'
import useAuthStore from '@/stores/auth'

const emit = defineEmits(['load'])

const props = defineProps({
  src: {
    type: String,
    required: true
  },
  params: {
    type: Object,
    default () { return { } }
  }
})

const pages = reactive([])
const items = reactive([])
const src = ref(props.src)
const paginate = ref(true)
const auth = useAuthStore()

const isFetching = computed(() => pages.some(page => page.isFetching))
const isEmpty = computed(() => {
  const page = pages[0]
  return page?.isFinished && !page.error && page.data.length === 0
})

function load (params = {}) {
  const page = useFetch(src.value, {
    immediate: false,
    params,
    afterFetch ({ data, response }) {
      items.push(...Array.from(data))

      const links = LinkHeader.parse(response.headers.get('Link') ?? '')
      if (links.has('rel', 'next')) {
        src.value = links.get('rel', 'next')[0].uri
      } else {
        paginate.value = false
      }
    }
  }).get().json()

  page.onFetchResponse(() => {
    emit('load', page)
  })

  pages.push(page)
  return page.execute(true) // true to throw on error
}

function reload () {
  pages.splice(0)
  items.splice(0)
  src.value = props.src
  paginate.value = true
  return load(props.params)
}

defineExpose({ items, pages, load, reload, isFetching, isEmpty })

// Reload data when signing in/out
watch(() => auth.isAuthenticated, reload)

await load(props.params)
</script>

<template>
  <slot
    v-if="$slots.empty && isEmpty"
    name="empty"
  />
  <template v-else>
    <template v-for="page in pages">
      <slot
        v-if="$slots.page"
        name="page"
        v-bind="page"
      />
    </template>
    <slot v-bind="{ items, ...pages[0] }" />
  </template>

  <ion-infinite-scroll
    v-if="paginate"
    :disabled="isFetching"
    threshold="500px"
    @ion-infinite="load().then(() => $event.target.complete())"
  >
    <ion-infinite-scroll-content
      loading-spinner="bubbles"
      loading-text="Loading…"
    />
  </ion-infinite-scroll>
</template>
