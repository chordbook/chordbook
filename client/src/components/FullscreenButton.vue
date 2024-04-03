<script setup>
import { useFullscreen } from '@vueuse/core'
import { ref, computed } from 'vue'
import { exit, expand } from '@/icons'

const props = defineProps({
  target: {
    type: String,
    default: () => 'ion-router-outlet'
  }
})

const el = ref()
const targetEl = computed(() => el.value?.closest?.(props.target))
const { isSupported, isFullscreen, toggle } = useFullscreen(targetEl)
</script>

<template>
  <ion-button
    v-if="isSupported"
    ref="el"
    style="--overflow: visible"
    v-tooltip="isFullscreen ? 'Exit Fullscreen' : 'Fullscreen'"
    @click="toggle"
  >
    <ion-icon
      slot="icon-only"
      :color="isFullscreen ? 'secondary' : 'default'"
      :icon="isFullscreen ? exit : expand"
    />
  </ion-button>
</template>
