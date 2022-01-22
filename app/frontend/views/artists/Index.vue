<template>
  <div class="bg-slate-100 dark:bg-slate-800 min-h-full">
    <div class="max-w-8xl mx-auto p-4 md:p-6 lg:p-8">
      <alpha-paginate />

      <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 xl:grid-cols-8 gap-10">
        <artist-list-item
          v-for="artist in artists"
          :key="artist.id"
          :artist="artist"
        />
      </div>
    </div>
  </div>
</template>

<script>
import api from '~/client'
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
