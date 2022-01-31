<template>
  <div class="ion-padding">
    <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-2">
      <ion-card
        v-for="genre in genres"
        :key="genre.id"
        button
        :style="style(genre.name)"
        :router-link="{ name: 'genre', params: { id: genre.id, genre } }"
        class="relative"
      >
        <ion-img
          :src="genre.thumbnail"
          class="object-cover object-center absolute inset-0 w-full h-full opacity-50 saturate-0 mix-blend-luminosity"
        />
        <div
          translucent
          class="aspect-4/3 flex items-end p-3"
        >
          <ion-card-title class="text-shadow font-bold text-lg sm:text-xl text-white">
            {{ genre.name }}
          </ion-card-title>
        </div>
      </ion-card>
    </div>
  </div>
</template>

<script>
import client from '@/client'
import { gradient } from '@/lib/gradient'
import { IonCard, IonCardTitle, IonImg } from '@ionic/vue'

export default {
  components: { IonCard, IonCardTitle, IonImg },

  data () {
    return {
      genres: []
    }
  },

  created () {
    this.fetchData()
  },

  methods: {
    async fetchData () {
      this.genres = (await client.get('/api/genres.json')).data
    },

    style (uid) {
      return `background-image: ${gradient(uid, { colors: 3, spin: 40 })}`
    }
  }
}
</script>

<style scoped>
ion-card {
  margin-inline-start: 0 !important;
  margin-inline-end: 0 !important;
  margin-top: 0 !important;
  margin-bottom: 0 !important;
}
</style>
