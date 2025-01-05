<script lang="ts" setup>
import getYoutubeId from "get-youtube-id";
import { computed } from "vue";

const { src } = defineProps<{
  src: string;
}>();

const id = computed(() => getYoutubeId(src));
</script>

<template>
  <iframe
    class="aspect-16/9 w-full"
    :src="`https://www.youtube.com/embed/${id}`"
    title="YouTube video player"
    frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
    allowfullscreen
  />
</template>
