<script setup>
import ArtistCard from '@/components/ArtistCard.vue'
import AlbumItem from '@/components/AlbumItem.vue'
import TrackItem from '@/components/TrackItem.vue'

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

          <div class="grid-scroll-x grid-rows-3 auto-cols-1/1 sm:auto-cols-1/2 lg:auto-cols-1/3 2xl:auto-cols-1/4">
            <data-source
              v-slot="{ data }"
              :src="`genres/${id}/tracks`"
            >
              <track-item
                v-for="track in data"
                :key="track.id"
                :track="track"
              />
            </data-source>
          </div>
        </ion-list>

        <ion-list>
          <ion-list-header>
            <ion-label>Top Artists</ion-label>
            <ion-button :router-link="{ name: 'genre.artists', params: { id } }">
              See All
            </ion-button>
          </ion-list-header>

          <div class="grid-scroll-x auto-cols-1/2 sm:auto-cols-1/3 md:auto-cols-1/4 lg:auto-cols-1/5 xl:auto-cols-1/6 2xl:auto-cols-1/8">
            <data-source
              v-slot="{ data }"
              :src="`genres/${id}/artists`"
            >
              <artist-card
                v-for="artist in data"
                :key="artist.id"
                :artist="artist"
              />
            </data-source>
          </div>
        </ion-list>

        <ion-list>
          <ion-list-header>
            <ion-label>Top Albums</ion-label>
            <ion-button :router-link="{ name: 'genre.albums', params: { id } }">
              See All
            </ion-button>
          </ion-list-header>

          <div class="grid-scroll-x auto-cols-1/2 sm:auto-cols-1/3 md:auto-cols-1/4 lg:auto-cols-1/5 xl:auto-cols-1/6 2xl:auto-cols-1/8">
            <data-source
              v-slot="{ data }"
              :src="`genres/${id}/albums`"
            >
              <album-item
                v-for="album in data"
                :key="album.id"
                :album="album"
              />
            </data-source>
          </div>
        </ion-list>
      </ion-content>
    </data-source>
  </app-view>
</template>
