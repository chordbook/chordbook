<template>
  <div class="bg-slate-100 dark:bg-slate-800 min-h-full">
    <div class="max-w-8xl mx-auto p-4 md:p-6 lg:p-8">
      <alpha-paginate />

      <ul class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 xl:grid-cols-8 gap-10">
        <li
          v-for="artist in artists"
          :key="artist.id"
        >
          <router-link
            :to="{ name: 'artist', params: { id: artist.id }}"
            class="block"
          >
            <div class="bg-white dark:bg-slate-900 shadow-md hover:shadow-lg relative overflow-hidden rounded-full">
              <canvas
                width="400"
                height="400"
              />
              <img
                v-if="artist.thumbnail"
                :src="artist.thumbnail"
                class="w-full h-full absolute inset-0"
              >
            </div>
            <div class="mt-3 text-center">
              <h3 class="whitespace-nowrap text-sm font-bold overflow-hidden text-ellipsis">
                {{ artist.name }}
              </h3>
              <div class="text-xs opacity-70">
                Artist
              </div>
            </div>
          </router-link>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import api from '~/api'
import alphaPaginate from '../../components/alpha-paginate.vue'

export default {
  components: { alphaPaginate },
  data () {
    return {
      artists: []
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
      this.artists = (await api.get('/api/artists.json', { params: this.$route.query })).data
    }
  }
}
</script>
