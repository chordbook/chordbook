<script lang="ts" setup>
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
    type: [String, null],
    default: null,
  },
});
</script>

<template>
  <IonItem
    button
    :router-link="{ name: 'artist', params: { id } }"
    class="rounded group"
    :detail="false"
    lines="none"
  >
    <IonLabel class="me-0">
      <div>
        <ModelAvatar
          :src="thumbnail"
          type="Artist"
          class="w-full h-full aspect-square mb-3 shadow-md"
        />
      </div>
      <h3 class="text-center">
        {{ name }}
      </h3>
    </IonLabel>
  </IonItem>
</template>
