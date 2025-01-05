<script lang="ts" setup>
import ModelAvatar from "./ModelAvatar.vue";

import type { Artist } from "@/api";

defineProps<Artist>();
</script>

<template>
  <IonItem button :router-link="{ name: 'artist', params: { id } }">
    <ModelAvatar slot="start" :src="thumbnail" type="artist" />
    <IonLabel>
      <h2>{{ name }}</h2>
    </IonLabel>
  </IonItem>
</template>
