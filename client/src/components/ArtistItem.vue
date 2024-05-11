<script setup>
import ModelAvatar from "./ModelAvatar.vue";

defineProps({
  id: {
    type: String,
    required: true,
  },
  name: {
    type: String,
    required: true,
  },
  thumbnail: {
    type: String,
    required: true,
  },
});
</script>

<template>
  <ion-item button :router-link="{ name: 'artist', params: { id } }">
    <model-avatar slot="start" :src="thumbnail" type="artist" />
    <ion-label>
      <h2>{{ name }}</h2>
    </ion-label>
  </ion-item>
</template>
