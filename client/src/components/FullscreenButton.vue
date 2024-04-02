<script setup>
import { useFullscreen } from '@vueuse/core'
import { ref, onMounted } from 'vue'
import { exit, expand } from '@/icons'

const props = defineProps({
  target: {
    type: String,
    default: () => 'ion-router-outlet'
  }
})

const el = ref()
const targetEl = ref()
const { isSupported, isFullscreen, toggle } = useFullscreen(targetEl)

onMounted(() => {
  targetEl.value = el.value.closest?.(props.target)
})
</script>

<template>
  <ion-button
    v-if="isSupported"
    ref="el"
    @click="toggle"
  >
    <ion-icon
      slot="icon-only"
      :color="isFullscreen ? 'secondary' : 'default'"
      :icon="isFullscreen ? exit : expand"
    />
  </ion-button>
</template>
