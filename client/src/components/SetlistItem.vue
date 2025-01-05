<script lang="ts" setup>
import * as icons from "@/icons";

defineProps<{
  title: string;
  thumbnails: string[];
}>();
</script>

<template>
  <ion-item button class="rounded group" :detail="false" lines="none">
    <ion-avatar
      slot="start"
      class="bg-slate-100 dark:bg-slate-800 flex place-content-center items-center rounded"
    >
      <div class="overflow-hidden relative aspect-square flex place-content-center items-center">
        <div v-if="thumbnails.length > 0" class="grid grid-cols-2 grid-rows-2">
          <img v-for="thumbnail in thumbnails" :key="thumbnail" :src="thumbnail" />
        </div>
        <ion-icon v-else :icon="icons.setlist" size="small" class="text-slate-300 text-5xl" />
      </div>
    </ion-avatar>

    <ion-label>
      <h3 class="text-sm">
        {{ title }}
      </h3>
    </ion-label>
  </ion-item>
</template>
