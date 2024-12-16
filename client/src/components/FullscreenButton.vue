<script setup>
import { useFullscreen } from "@vueuse/core";
import { ref, computed } from "vue";
import { exit, expand } from "@/icons";

const props = defineProps({
  target: {
    type: String,
    default: () => "ion-router-outlet",
  },
});

const el = ref();
const targetEl = computed(() => el.value?.closest?.(props.target));
const { isSupported, isFullscreen, toggle } = useFullscreen(targetEl);
</script>

<template>
  <ion-item
    v-if="isSupported"
    ref="el"
    button
    detail
    :detail-icon="isFullscreen ? exit : expand"
    @click="toggle"
  >
    {{ isFullscreen ? 'Exit Fullscreen' : 'Fullscreen' }}
    <!-- <ion-icon
      slot="icon-only"
      :color="isFullscreen ? 'secondary' : 'default'"

    /> -->
  </ion-item>
</template>
