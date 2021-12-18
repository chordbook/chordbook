<template>
  <div class="max-w-8xl mx-auto p-4 md:p-6 lg:p-8">
    <h2>Recently Added</h2>

    <ul>
      <li
        v-for="songsheet in songsheets"
        :key="songsheet.id"
        class="my-4"
      >
        <router-link :to="{ name: 'songsheet', params: { id: songsheet.id }}">
          <strong>{{ songsheet.title }}</strong>
          <div>{{ songsheet.subtitle }}</div>
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
    next(vm => (vm.songsheets = response.data))
  },

  data () {
    return {
      songsheets: []
    }
  }
}
</script>
