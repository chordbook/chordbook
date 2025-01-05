<script setup lang="ts">
import type { Track } from "@/api";
import TrackItem from "@/components/TrackItem.vue";
</script>

<template>
  <app-view>
    <Head>
      <title>Songs</title>
    </Head>
    <ion-header translucent collapse="fade">
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button text="" :default-href="$route.path.replace('/tracks', '')" />
        </ion-buttons>
        <ion-title>Songs</ion-title>
      </ion-toolbar>
    </ion-header>

    <ion-content fullscreen class="main-content">
      <data-source v-slot="{ items }: { items: Track[] }" :src="$route.path" :params="$route.query">
        <ion-list>
          <track-item v-for="track in items" :key="track.id" v-bind="track" />
        </ion-list>
      </data-source>
    </ion-content>
  </app-view>
</template>
