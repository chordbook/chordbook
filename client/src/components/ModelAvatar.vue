<script lang="ts" setup>
import { computed } from "vue";
import { artist, album, song } from "@/icons";

const icons = {
  artist,
  album,
  track: song,
  songsheet: song,
};

const props = defineProps<{
  src?: string | null;
  type: string;
}>();

const borderRadius = computed(() =>
  props.type.toLowerCase() === "artist" ? "50%" : "0.25rem",
);
</script>

<template>
  <ion-avatar
    class="bg-slate-500/20 text-slate-500 flex place-content-center items-center overflow-hidden relative"
    :style="{ '--border-radius': borderRadius }"
  >
    <img v-if="src" :src="src" />
    <ion-icon v-else :icon="icons[type.toLowerCase() as keyof typeof icons]" size="large" />
  </ion-avatar>
</template>
