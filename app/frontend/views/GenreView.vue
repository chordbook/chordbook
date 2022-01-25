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
          <ion-button>See All</ion-button>
        </ion-list-header>

        <track-item
          v-for="track in genre.tracks"
          :key="track.id"
          :track="track"
        />
      </ion-list>

      <ion-list v-if="genre.artists?.length > 0">
        <ion-list-header>
          <ion-label>Top Artists</ion-label>
          <ion-button>See All</ion-button>
        </ion-list-header>

        <artist-item
          v-for="artist in genre.artists"
          :key="artist.id"
          :artist="artist"
        />
      </ion-list>

      <ion-list v-if="genre.albums?.length > 0">
        <ion-list-header>
          <ion-label>Top Albums</ion-label>
          <ion-button>See All</ion-button>
        </ion-list-header>

        <album-item
          v-for="album in genre.albums"
          :key="album.id"
          :album="album"
        />
      </ion-list>
    </ion-content>
  </ion-page>
</template>

<script>
import client from '@/client'
import { gradient } from '@/lib/gradient'
import { IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonButtons, IonBackButton, IonList, IonListHeader, IonLabel, IonButton } from '@ionic/vue'
import ArtistItem from '@/components/ArtistItem.vue'
import AlbumItem from '@/components/AlbumItem.vue'
import TrackItem from '@/components/TrackItem.vue'

export default {
  components: { ArtistItem, AlbumItem, TrackItem, IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonButtons, IonBackButton, IonList, IonListHeader, IonLabel, IonButton },

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

  watch: {
    $route: 'fetchData'
  },

  created () {
    this.fetchData()
  },

  methods: {
    async fetchData () {
      this.genre = (await client.get(`/api/genres/${this.$route.params.id}.json`)).data
    }
  }
}
</script>
