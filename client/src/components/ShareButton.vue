<script setup>
import 'share-api-polyfill'
import { share } from '@/icons'
import { computed } from 'vue'
import { useRouter } from 'vue-router'

const props = defineProps({
  routerLink: {
    type: [String, Object],
    required: true
  },
  title: {
    type: String,
    required: true
  }
})

const router = useRouter()
const data = computed(() => {
  return {
    title: props.title,
    url: new URL(router.resolve(props.routerLink).href, window.location).toString()
  }
})

function doShare () {
  return navigator.share(data.value)
}
</script>

<template>
  <ion-button @click="doShare">
    <ion-icon
      slot="icon-only"
      :icon="share"
    />
  </ion-button>
</template>
