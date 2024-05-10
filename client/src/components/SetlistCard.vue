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
    class="rounded group @container"
    :detail="false"
    lines="none"
  >
    <ion-label class="me-0 relative aspect-square rounded-lg overflow-hidden">
      <div class="absolute inset-0 w-full h-full">
        <SetlistAvatar
          :id="id"
          :thumbnails="thumbnails"
        />
      </div>
      <div
        class="relative w-full h-full flex items-end p-4 bg-gradient-to-b from-transparent from-50% to-black/60 to-90%"
      >
        <div
          class="text-shadow font-semibold text-white text-balance line-clamp-3"
        >
          {{ title }}
        </div>
      </div>
    </ion-label>
  </ion-item>
</template>

<style scoped>
/* ion-item {
  --padding-start: 0;
  --inner-padding-end: 0;
  @apply m-[16px];
}

ion-label {
  @apply m-0;
} */
</style>
