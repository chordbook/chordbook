<script setup>
import ModelList from '@/components/ModelList.vue'

defineProps({
  id: {
    type: String,
    required: true
  }
})
</script>

<template>
  <app-view>
    <data-source
      v-slot="genre"
      :src="`genres/${id}`"
    >
      <ion-header translucent>
        <ion-toolbar>
          <ion-buttons slot="start">
            <ion-back-button
              text=""
              default-href="/discover"
            />
          </ion-buttons>
          <ion-title>{{ genre.data?.name }}</ion-title>
        </ion-toolbar>
      </ion-header>

      <ion-content>
        <ion-header collapse="condense">
          <ion-toolbar>
            <ion-title size="large">
              {{ genre.data?.name }}
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

          <data-source
            v-slot="{ data }"
            :src="`genres/${id}/tracks`"
          >
            <model-list :items="data" />
          </data-source>
        </ion-list>

        <ion-list>
          <ion-list-header>
            <ion-label>Top Artists</ion-label>
            <ion-button :router-link="{ name: 'genre.artists', params: { id } }">
              See All
            </ion-button>
          </ion-list-header>

          <data-source
            v-slot="{ data }"
            :src="`genres/${id}/artists`"
          >
            <model-list
              :items="data"
              format="card"
            />
          </data-source>
        </ion-list>

        <ion-list>
          <ion-list-header>
            <ion-label>Top Albums</ion-label>
            <ion-button :router-link="{ name: 'genre.albums', params: { id } }">
              See All
            </ion-button>
          </ion-list-header>

          <data-source
            v-slot="{ data }"
            :src="`genres/${id}/albums`"
          >
            <model-list
              :items="data"
              format="card"
            />
          </data-source>
        </ion-list>
      </ion-content>
    </data-source>
  </app-view>
</template>
