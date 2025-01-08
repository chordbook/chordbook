<script setup lang="ts">
import WaitableEvent from "@/WaitableEvent";
import {
  IonInfiniteScroll,
  IonInfiniteScrollContent,
  IonRefresher,
  IonRefresherContent,
  type InfiniteScrollCustomEvent,
  type RefresherCustomEvent,
} from "@ionic/vue";
import { useCurrentElement } from "@vueuse/core";
import { computed } from "vue";

const { paginate = true } = defineProps<{ paginate: boolean }>();

const emit = defineEmits<{
  load: [e: WaitableEvent];
  reload: [e: WaitableEvent];
}>();

const el = useCurrentElement<HTMLElement>();
const contentElement = computed(() => el.value?.parentElement?.closest("ion-content"));

function reload(event: RefresherCustomEvent) {
  emit(
    "reload",
    new WaitableEvent(
      () => event.target.complete(),
      () => event.target.cancel(),
    ),
  );
}

function load(event: InfiniteScrollCustomEvent) {
  emit("load", new WaitableEvent(() => event.target.complete()));
}
</script>

<template>
  <Teleport v-if="contentElement" :to="contentElement">
    <IonRefresher slot="fixed" @ion-refresh="reload">
      <IonRefresherContent />
    </IonRefresher>
  </Teleport>

  <slot />

  <IonInfiniteScroll v-if="paginate" @ion-infinite="load">
    <IonInfiniteScrollContent loading-spinner="bubbles" loading-text="Loading…" />
  </IonInfiniteScroll>
</template>
