<script lang="ts" setup>
import { exit, expand } from "@/icons";
import { useFullscreen } from "@vueuse/core";
import { computed, ref } from "vue";

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
  <IonButton
    v-if="isSupported"
    ref="el"
    v-tooltip="isFullscreen ? 'Exit Fullscreen' : 'Fullscreen'"
    style="--overflow: visible"
    @click="toggle"
  >
    <IonIcon
      slot="icon-only"
      :color="isFullscreen ? 'secondary' : 'default'"
      :icon="isFullscreen ? exit : expand"
    />
  </IonButton>
</template>
