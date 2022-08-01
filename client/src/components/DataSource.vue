<script setup>
import { defineProps, reactive, ref, computed } from 'vue'
import { useFetch } from '@/client'
import LinkHeader from 'http-link-header'

const props = defineProps({
  src: {
    type: String,
    required: true
  },
  params: {
    type: Object,
    default () { return { } }
  },
  paginate: {
    type: Boolean,
    default: false
  }
})

const pages = ref([])

async function load (src = props.src, params = props.params) {
  const page = reactive(useFetch(src, { params }).get().json())
  page.then(() => console.log("DONE!", page))
  return pages.value.push(page)

  // return pages.value.push(reactive(useFetch(src, { params }).get().json()))
}

const nextSrc = computed(() => {
  const links = LinkHeader.parse(lastPage.value.response.headers.get('Link') ?? '')

  if (links.has('rel', 'next')) {
    return links.get('rel', 'next')[0].uri
  }

  return false
})
const lastPage = computed(() => pages.value.slice(-1)[0])
const isDisabled = computed(() => !lastPage.value || lastPage.value.isFetching)

load()
</script>

<template>
  <template v-for="page in pages">
    <slot v-bind="page" />
  </template>

  <ion-infinite-scroll
    v-if="paginate"
    threshold="500px"
    :disabled="isDisabled"
    @ion-infinite="load(nextSrc).then(() => $event.target.complete())"
  >
    <ion-infinite-scroll-content
      loading-spinner="bubbles"
      loading-text="Loading…"
    />
  </ion-infinite-scroll>
</template>
