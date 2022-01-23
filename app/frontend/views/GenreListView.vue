<template>
  <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6">
    <ion-card
      v-for="genre in genres"
      :key="genre.id"
      :style="style(genre.name)"
    >
      <router-link
        :to="{ name: 'genre', params: { id: genre.id, genre } }"
        class="aspect-4/3 relative flex items-end"
      >
        <img
          :src="genre.thumbnail"
          class="object-cover object-center absolute inset-0 w-full h-full opacity-50 saturate-0 mix-blend-luminosity"
        >
        <ion-card-header>
          <ion-card-title class="text-shadow font-bold text-shadow text-xl text-white">
            {{ genre.name }}
          </ion-card-title>
        </ion-card-header>
      </router-link>
    </ion-card>
  </div>
</template>

<script>
import client from '@/client'
import { gradient } from '@/lib/gradient'
import { IonCard, IonCardTitle, IonCardHeader } from '@ionic/vue'

export default {
  components: { IonCard, IonCardTitle, IonCardHeader },

  data () {
    return {
      genres: []
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
      this.genres = (await client.get('/api/genres.json')).data
    },

    style (uid) {
      return `background-image: ${gradient(uid, { colors: 3, spin: 40 })}`
    }
  }
}
</script>
