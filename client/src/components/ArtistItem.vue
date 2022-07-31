<script setup>
import { artist } from '@/icons'

defineProps({
  id: {
    type: String,
    required: true
  },
  name: {
    type: String,
    required: true
  },
  thumbnail: {
    type: String,
    required: true
  }
})
</script>

<template>
  <ion-item
    button
    :router-link="{ name: 'artist', params: { id } }"
  >
    <ion-avatar
      slot="start"
      class="bg-slate-100 flex place-content-center items-center"
    >
      <img
        v-if="thumbnail"
        :src="thumbnail"
      >
      <ion-icon
        v-else
        :icon="artist"
        class="text-slate-300"
      />
    </ion-avatar>
    <ion-label>
      <h2>{{ name }}</h2>
    </ion-label>
  </ion-item>
</template>
