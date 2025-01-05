<script setup lang="ts">
import type { Genre } from "@/api";
import { gradient } from "@/lib/gradient";

function style(uid: string) {
  return `background-image: ${gradient(uid, { colors: 3, spin: 40 })}`;
}
</script>

<template>
  <div>
    <IonListHeader>Browse by Genre</IonListHeader>
    <DataSource src="genres">
      <template #page="{ data }: { data: Genre[] }">
        <div
          class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 xl:grid-cols-6 2xl:grid-cols-8 gap-[32px] ion-margin"
        >
          <IonCard
            v-for="genre in data"
            :key="genre.id"
            button
            :style="style(genre.name)"
            :router-link="{ name: 'genre', params: { id: genre.id, genre } }"
            class="relative"
          >
            <img
              v-if="genre.thumbnail"
              :src="genre.thumbnail"
              class="object-cover object-center absolute inset-0 w-full h-full opacity-50 saturate-0 mix-blend-luminosity"
            />
            <div class="aspect-square flex items-end p-4">
              <IonCardTitle class="text-shadow font-bold text-lg sm:text-xl text-white">
                {{ genre.name }}
              </IonCardTitle>
            </div>
          </IonCard>
        </div>
      </template>
    </DataSource>
  </div>
</template>

<style scoped>
ion-card {
  margin-inline-start: 0 !important;
  margin-inline-end: 0 !important;
  margin-top: 0 !important;
  margin-bottom: 0 !important;
}
</style>
