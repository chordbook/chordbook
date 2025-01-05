<script lang="ts" setup>
import ModelAvatar from "./ModelAvatar.vue";

import type { Artist } from "@/api";

defineProps<Artist>();
</script>

<template>
  <ion-item button :router-link="{ name: 'artist', params: { id } }">
    <model-avatar slot="start" :src="thumbnail" type="artist" />
    <ion-label>
      <h2>{{ name }}</h2>
    </ion-label>
  </ion-item>
</template>
