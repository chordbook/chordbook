<template>
  <div class="bg-gray-100 dark:bg-gray-800 h-full">
    <div class="max-w-8xl mx-auto p-4 md:p-6">
      <ul class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-6">
        <li
          v-for="artist in artists"
          :key="artist.id"
        >
          <router-link
            :to="{ name: 'artist', params: { id: artist.id }}"
            class="block"
          >
            <div class="bg-white dark:bg-gray-900 shadow hover:shadow-lg relative overflow-hidden">
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
            <div class="mt-2 whitespace-nowrap overflow-hidden text-ellipsis">
              {{ artist.name }}
            </div>
          </router-link>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import api from '~/api'

export default {
  async beforeRouteEnter (to, from, next) {
    const response = await api.get('/api/artists.json')
    next(vm => (vm.artists = response.data))
  },

  data () {
    return {
      artists: []
    }
  }
}
</script>
