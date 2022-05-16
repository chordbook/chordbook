<script>
import getYoutubeId from 'get-youtube-id'

export default {
  props: {
    uri: {
      type: String,
      required: true
    }
  },

  computed: {
    id () {
      return getYoutubeId(this.uri)
    },

    src () {
      return `https://www.youtube.com/embed/${this.id}`
    }
  }
}
</script>

<template>
  <iframe
    class="aspect-16/9 w-full"
    :src="src"
    title="YouTube video player"
    frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
    allowfullscreen
  />
</template>
