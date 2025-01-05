<script setup lang="ts">
import ArtistItem from "@/components/ArtistItem.vue";
import LibraryPlaceholder from "@/components/LibraryPlaceholder.vue";

import type { Artist } from "@/api";
</script>

<template>
  <app-view>
    <Head>
      <title>Artists</title>
    </Head>
    <ion-header translucent>
      <ion-toolbar>
        <ion-title>Artists</ion-title>

        <ion-buttons slot="start">
          <ion-back-button
            class="md:hidden"
            text=""
            :default-href="$route.path.replace('/artists', '') || '/library'"
          />
        </ion-buttons>
      </ion-toolbar>
    </ion-header>

    <ion-content fullscreen class="main-content">
      <ion-header collapse="condense">
        <ion-toolbar>
          <ion-title size="large"> Artists </ion-title>
        </ion-toolbar>
      </ion-header>
      <data-source :src="$route.path" :params="$route.query">
        <template #empty>
          <library-placeholder type="artist" />
        </template>
        <template #default="{ items }: { items: Artist[] }">
          <ion-list>
            <artist-item v-for="artist in items" :key="artist.id" v-bind="artist" />
          </ion-list>
        </template>
      </data-source>
    </ion-content>
  </app-view>
</template>
