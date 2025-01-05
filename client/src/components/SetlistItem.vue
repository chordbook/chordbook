<script lang="ts" setup>
import * as icons from "@/icons";

defineProps<{
  title: string;
  thumbnails: string[];
}>();
</script>

<template>
  <IonItem button class="rounded group" :detail="false" lines="none">
    <IonAvatar
      slot="start"
      class="bg-slate-100 dark:bg-slate-800 flex place-content-center items-center rounded"
    >
      <div class="overflow-hidden relative aspect-square flex place-content-center items-center">
        <div v-if="thumbnails.length > 0" class="grid grid-cols-2 grid-rows-2">
          <img v-for="thumbnail in thumbnails" :key="thumbnail" :src="thumbnail" />
        </div>
        <IonIcon v-else :icon="icons.setlist" size="small" class="text-slate-300 text-5xl" />
      </div>
    </IonAvatar>

    <IonLabel>
      <h3 class="text-sm">
        {{ title }}
      </h3>
    </IonLabel>
  </IonItem>
</template>
