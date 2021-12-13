<template>
  <div class="bg-gray-100 dark:bg-gray-800 min-h-full">
    <div
      class="bg-black relative bg-cover bg-fixed"
      :style="`background-image: url(${artist.banner});`"
    >
      <div class="absolute inset-0 bg-gradient-to-b to-black from-transparent" />
      <div class="relative max-w-8xl mx-auto p-4 md:p-6 h-full min-h-screen-2/3 flex flex-col place-content-end">
        <h1 class="text-white text-shadow-md text-5xl font-bold">
          {{ artist.name }}
        </h1>
        <div class="opacity-50">{{ artist.metadata?.strStyle }}</div>
      </div>
    </div>

    <div class="max-w-8xl mx-auto p-4 md:p-6">
      <p
        class="my-4 text-sm line-clamp-3"
        onclick="this.classList.toggle('line-clamp-3')"
      >
        {{ artist.biography }}
      </p>

      <div v-if="albums.length > 0" class="my-6">
        <h2 class="text-2xl mb-3">Albums</h2>

        <ul class="grid grid-cols-6 gap-6">
          <li v-for="album in albums">
            <a href="" class="block">
              <div class="bg-white dark:bg-gray-900 shadow hover:shadow-lg relative overflow-hidden">
                <canvas
                  width="200"
                  height="200"
                />
                <img
                  v-if="album.thumbnail"
                  :src="album.thumbnail"
                  class="absolute inset-0"
                >
              </div>
              <div class="mt-2 text-ellipsis">
                {{ album.title }}
              </div>
            </a>
          </li>
        </ul>
      </div>
      <div class="my-6">
        <h2 class="text-2xl mb-3">Popular Songs</h2>
        <ul>
          <li v-for="track in tracks" class="my-3">
            <a href="" class="flex gap-4">
              <div class="relative bg-black">
                <canvas width="40" height="40"></canvas>
                <img v-if="track.album.thumbnail" :src="track.album.thumbnail" class="absolute inset-0">
              </div>
              <div>
                <div>{{ track.title }}</div>
                <div class="text-sm opacity-50">{{ track.album?.title }}</div>
              </div>
            </a>
          </li>
        </ul>

        <a href="">View All</a>
      </div>
    </div>
  </div>
</template>

<script>
import api from '~/api'

export default {
  async beforeRouteEnter (to, from, next) {
    return api.get(`/api/artists/${to.params.id}.json`).then(response => {
      next(vm => {
        vm.artist = response.data

        api.get(`/api/artists/${to.params.id}/albums.json`).then(response => {
          vm.albums = response.data
        })

        api.get(`/api/artists/${to.params.id}/tracks.json`).then(response => {
          vm.tracks = response.data
        })
      })
    }).catch(() => {
      next({ name: '404' })
    })
  },

  data () {
    return {
      artist: {},
      tracks: [],
      albums: []
    }
  }
}
</script>
