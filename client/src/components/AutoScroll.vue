<script setup>
import { useAutoScroll } from '@/composables'
import { reactive, defineExpose, ref } from 'vue'

const props = defineProps({
  duration: {
    type: Number,
    default: 0
  }
})

const scroller = ref()
const autoScroll = reactive(useAutoScroll(scroller, props.duration))

defineExpose(autoScroll)
</script>

<template>
  <ion-content
    ref="scroller"
    v-bind="autoScroll"
  >
    <slot />
  </ion-content>
</template>
