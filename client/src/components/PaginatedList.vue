<script setup lang="ts">
import type { usePaginatedFetch } from "@/composables";
import { useCurrentElement } from "@vueuse/core";
import { computed } from "vue";

defineProps<{
  dataSource: ReturnType<typeof usePaginatedFetch>;
}>();

const el = useCurrentElement<HTMLElement>();
const contentElement = computed(() => el.value?.parentElement?.closest("ion-content"));
</script>

<template>
  <Teleport :disabled="!contentElement" defer :to="contentElement">
    <ion-refresher slot="fixed" @ion-refresh="dataSource.reload($event)">
      <ion-refresher-content />
    </ion-refresher>
  </Teleport>

  <slot />

  <ion-infinite-scroll
    v-if="dataSource.isPaginating"
    @ion-infinite="dataSource.load().then(() => $event.target.complete())"
  >
    <ion-infinite-scroll-content loading-spinner="bubbles" loading-text="Loading…" />
  </ion-infinite-scroll>
</template>
