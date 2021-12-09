<template>
  <div class="max-w-8xl mx-auto p-4 md:p-6">
    <h2>Recently Added</h2>

    <ul>
      <li
        v-for="song in songs"
        :key="song.id"
        class="my-4"
      >
        <router-link :to="{ name: 'song', params: { id: song.id }}">
          <strong>{{ song.title }}</strong>
          <div>{{ song.subtitle }}</div>
        </router-link>
      </li>
    </ul>
  </div>
</template>

<script>
import api from '~/api'

export default {
  async beforeRouteEnter (to, from, next) {
    const response = await api.get('/api/songsheets.json')
    next(vm => (vm.songs = response.data))
  },

  data () {
    return {
      songs: []
    }
  }
}
</script>
