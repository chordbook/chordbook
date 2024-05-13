<script>
import getYoutubeId from "get-youtube-id";

export default {
  props: {
    src: {
      type: String,
      required: true,
    },
  },

  computed: {
    id() {
      return getYoutubeId(this.src);
    },

    iframeSrc() {
      return `https://www.youtube.com/embed/${this.id}`;
    },
  },
};
</script>

<template>
  <iframe
    class="aspect-16/9 w-full"
    :src="iframeSrc"
    title="YouTube video player"
    frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
    allowfullscreen
  />
</template>
