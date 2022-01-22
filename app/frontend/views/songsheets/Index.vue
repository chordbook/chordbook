<template>
  <div class="max-w-8xl mx-auto p-4 md:p-6 lg:p-8">
    <alpha-paginate />

    <ul>
      <songsheet-list-item
        v-for="songsheet in songsheets"
        :key="songsheet.id"
        :songsheet="songsheet"
      />
    </ul>
  </div>
</template>

<script>
import api from '~/client'

export default {
  data () {
    return {
      songsheets: []
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
      this.songsheets = (await api.get('/api/songsheets.json', { params: this.$route.query })).data
    }
  }
}
</script>
