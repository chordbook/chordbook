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
    class="rounded group"
    :detail="false"
    lines="none"
  >
    <ion-label>
      <div>
        <ion-avatar
          class="w-full h-full flex place-content-center items-center overflow-hidden relative aspect-square shadow-md bg-slate-100 dark:bg-slate-900 mb-3"
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
      </div>
      <h3 class="text-center">
        {{ name }}
      </h3>
    </ion-label>
  </ion-item>
</template>
