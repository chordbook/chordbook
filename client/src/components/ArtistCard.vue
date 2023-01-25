<script setup>
import ModelAvatar from './ModelAvatar.vue'

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
        <model-avatar
          :src="thumbnail"
          type="Artist"
          class="w-full h-full mb-3"
        />
      </div>
      <h3 class="text-center">
        {{ name }}
      </h3>
    </ion-label>
  </ion-item>
</template>
