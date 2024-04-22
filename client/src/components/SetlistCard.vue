<script setup>
import SetlistAvatar from '@/components/SetlistAvatar.vue'

defineProps({
  id: {
    type: String,
    required: true
  },
  title: {
    type: String,
    required: true
  },
  description: {
    type: String,
    default: null
  },
  thumbnails: {
    type: Array,
    required: true
  }
})
</script>

<template>
  <ion-item
    button
    :router-link="{ name: 'setlist', params: { id } }"
    class="rounded group"
    :detail="false"
    lines="none"
  >
    <ion-label class="me-0">
      <SetlistAvatar
        :id="id"
        :thumbnails="thumbnails"
      />
      <h3 class="text-sm">
        {{ title }}
      </h3>
      <p class="whitespace-normal line-clamp-3 text-xs">
        {{ description }}
      </p>
    </ion-label>
  </ion-item>
</template>
