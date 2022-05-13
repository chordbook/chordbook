<script setup>
import { defineProps } from 'vue'
import YoutubeEmbed from '@/components/YoutubeEmbed.vue'

defineProps({
  songsheet: {
    type: Object,
    required: true
  }
})
</script>

<template>
  <div class="fixed z-10 top-20 right-5 rounded shadow-md overflow-hidden w-96">
    <youtube-embed
      v-for="media in songsheet.media"
      :key="media.uri"
      v-bind="media"
    />
  </div>
</template>
