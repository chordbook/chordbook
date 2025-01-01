<script setup lang="ts">
import type { Genre, Track, Artist, Album } from '@/api';
defineProps<{ id: string }>();
</script>

<template>
  <app-view>
    <data-source v-slot="{ data: genre }: { data: Genre }" :src="`genres/${id}`">
      <Head>
        <title>
          {{ genre.name }}
        </title>
      </Head>
      <ion-header translucent>
        <ion-toolbar>
          <ion-buttons slot="start">
            <ion-back-button text="" default-href="/discover" />
          </ion-buttons>
          <ion-title>{{ genre.name }}</ion-title>
        </ion-toolbar>
      </ion-header>

      <ion-content fullscreen class="main-content">
        <ion-header collapse="condense">
          <ion-toolbar>
            <ion-title size="large">
              {{ genre.name }}
            </ion-title>
          </ion-toolbar>
        </ion-header>

        <ion-list>
          <ion-list-header>
            <ion-label>Top Songs</ion-label>
            <ion-button :router-link="{ name: 'genre.tracks', params: { id } }">
              See All
            </ion-button>
          </ion-list-header>

          <data-source v-slot="{ data }: { data: Track[] }" :src="`genres/${id}/tracks`">
            <model-list :items="data" />
          </data-source>
        </ion-list>

        <ion-list>
          <ion-list-header>
            <ion-label>Top Artists</ion-label>
            <ion-button
              :router-link="{ name: 'genre.artists', params: { id } }"
            >
              See All
            </ion-button>
          </ion-list-header>

          <data-source v-slot="{ data }: { data: Artist[] }" :src="`genres/${id}/artists`">
            <model-list :items="data" format="card" />
          </data-source>
        </ion-list>

        <ion-list>
          <ion-list-header>
            <ion-label>Top Albums</ion-label>
            <ion-button :router-link="{ name: 'genre.albums', params: { id } }">
              See All
            </ion-button>
          </ion-list-header>

          <data-source v-slot="{ data }: { data: Album[] }" :src="`genres/${id}/albums`">
            <model-list :items="data" format="card" />
          </data-source>
        </ion-list>
      </ion-content>
    </data-source>
  </app-view>
</template>
