<template>
  <ion-page>
    <ion-header translucent>
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button
            text=""
            default-href="/discover"
          />
        </ion-buttons>
        <ion-title>{{ genre.name }}</ion-title>
      </ion-toolbar>
    </ion-header>

    <ion-content>
      <ion-header collapse="condense">
        <ion-toolbar>
          <ion-title size="large">
            {{ genre.name }}
          </ion-title>
        </ion-toolbar>
      </ion-header>

      <ion-list v-if="genre.tracks?.length > 0">
        <ion-list-header>
          <ion-label>Top Songs</ion-label>
          <ion-button :router-link="{ name: 'genre.tracks', params: { id } }">
            See All
          </ion-button>
        </ion-list-header>

        <div class="grid-scroll-x grid-rows-3 auto-cols-1/1 sm:auto-cols-1/2 lg:auto-cols-1/3 2xl:auto-cols-1/4">
          <track-item
            v-for="track in genre.tracks"
            :key="track.id"
            :track="track"
          />
        </div>
      </ion-list>

      <ion-list v-if="genre.artists?.length > 0">
        <ion-list-header>
          <ion-label>Top Artists</ion-label>
          <ion-button :router-link="{ name: 'genre.artists', params: { id } }">
            See All
          </ion-button>
        </ion-list-header>

        <div class="grid-scroll-x auto-cols-1/2 sm:auto-cols-1/3 md:auto-cols-1/4 lg:auto-cols-1/5 xl:auto-cols-1/6 2xl:auto-cols-1/8">
          <artist-card
            v-for="artist in genre.artists"
            :key="artist.id"
            :artist="artist"
          />
        </div>
      </ion-list>

      <ion-list v-if="genre.albums?.length > 0">
        <ion-list-header>
          <ion-label>Top Albums</ion-label>
          <ion-button :router-link="{ name: 'genre.albums', params: { id } }">
            See All
          </ion-button>
        </ion-list-header>

        <div class="grid-scroll-x auto-cols-1/2 sm:auto-cols-1/3 md:auto-cols-1/4 lg:auto-cols-1/5 xl:auto-cols-1/6 2xl:auto-cols-1/8">
          <album-item
            v-for="album in genre.albums"
            :key="album.id"
            :album="album"
          />
        </div>
      </ion-list>
    </ion-content>
  </ion-page>
</template>

<script>
import client from '@/client'
import { gradient } from '@/lib/gradient'
import { IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonButtons, IonBackButton, IonList, IonListHeader, IonLabel, IonButton } from '@ionic/vue'
import ArtistCard from '@/components/ArtistCard.vue'
import AlbumItem from '@/components/AlbumItem.vue'
import TrackItem from '@/components/TrackItem.vue'

export default {
  components: { ArtistCard, AlbumItem, TrackItem, IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonButtons, IonBackButton, IonList, IonListHeader, IonLabel, IonButton },

  props: {
    id: {
      type: String,
      required: true
    }
  },

  data () {
    return {
      genre: {}
    }
  },

  computed: {
    style () {
      if (!this.genre.name) return ''
      return `background-image: ${gradient(this.genre.name, { colors: 4, spin: 22.5 })};`
    }
  },

  ionViewWillEnter () {
    return this.fetchData()
  },

  methods: {
    async fetchData () {
      this.genre = (await client.get(`genres/${this.id}.json`)).data
    }
  }
}
</script>
