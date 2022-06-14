<template>
  <ion-item
    button
    :router-link="{ name: 'setlist', params: { id: setlist.id } }"
    class="rounded group"
    :detail="false"
    lines="none"
  >
    <ion-label>
      <div class="rounded overflow-hidden relative aspect-square shadow-md bg-slate-100 dark:bg-slate-900 mb-2 flex place-content-center items-center">
        <div
          v-if="setlist.thumbnails.length > 0"
          class="grid grid-cols-2 grid-rows-2"
        >
          <img
            v-for="thumbnail in setlist.thumbnails"
            :key="thumbnail"
            :src="thumbnail"
          >
        </div>
        <ion-icon
          v-else
          :icon="icons.setlist"
          class="text-slate-300 text-5xl"
        />
      </div>
      <h3 class="text-sm">
        {{ setlist.title }}
      </h3>
      <p class="whitespace-normal line-clamp-3 text-xs">
        {{ setlist.description }}
      </p>
    </ion-label>
  </ion-item>
</template>

<script setup>
import { defineProps } from 'vue'
import * as icons from '@/icons'

defineProps({
  setlist: {
    type: Object,
    required: true
  }
})
</script>
