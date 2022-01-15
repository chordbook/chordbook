<template>
  <div class="grid grid-cols-5 gap-6">
    <router-link
      v-for="genre in genres"
      :key="genre"
      :to="{ name: 'genre', params: { id: genre.id } }"
      class="block rounded-md relative shadow-lg text-white"
      :style="style(genre.name)"
    >
      <canvas
        class="saturate-0 bg-cover opacity-20 mix-blend-luminosity"
        :style="genre.thumbnail ? `background-image: url(${genre.thumbnail})` : ''"
        width="500"
        height="500"
      />
      <div class="absolute inset-0 p-4 flex place-content-center items-end">
        <h2 class="text-xl font-bold text-shadow">
          {{ genre.name }}
        </h2>
      </div>
    </router-link>
  </div>
</template>

<script>
import api from '~/api'
import { gradient } from '~/lib/gradient'

export default {
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
      this.genres = (await api.get('/api/genres.json', { params: this.$route.query })).data
    },

    style (uid) {
      return `background-image: ${gradient(uid, { colors: 4, spin: 22.5 })};`
    }
  }
}
</script>
