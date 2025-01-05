<script setup lang="ts">
import { gradient } from "@/lib/gradient";

function style(uid: string) {
  return `background-image: ${gradient(uid, { colors: 3, spin: 40 })}`;
}
</script>

<template>
  <div>
    <ion-list-header>Browse by Genre</ion-list-header>
    <data-source v-slot="{ items }" src="genres">
      <div
        class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 xl:grid-cols-6 2xl:grid-cols-8 gap-[32px] ion-margin"
      >
        <ion-card
          v-for="genre in items"
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
            <ion-card-title class="text-shadow font-bold text-lg sm:text-xl text-white">
              {{ genre.name }}
            </ion-card-title>
          </div>
        </ion-card>
      </div>
    </data-source>
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
