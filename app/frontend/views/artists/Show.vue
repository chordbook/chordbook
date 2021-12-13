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

      <div class="my-6">
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
                {{ album.name }}
              </div>
            </a>
          </li>
        </ul>
      </div>
      <div class="my-6">
        <h2 class="text-2xl mb-3">Popular Songs</h2>
        <ul>
          <li v-for="song in songs" class="my-3">
            <a href="" class="flex gap-4">
              <div class="relative bg-black">
                <canvas width="40" height="40"></canvas>
                <img v-if="song.thumbnail" class="absolute inset-0">
              </div>
              <div>
                <div>{{ song.title }}</div>
                <div class="text-sm opacity-50">{{ song.album }}</div>
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
      next(vm => (vm.artist = response.data))
    }).catch(() => {
      next({ name: '404' })
    })
  },

  data () {
    return {
      artist: {},
      songs: [
        { id: 1, title: 'Across the Universe', album: "Album name" },
        { id: 1, title: 'Here Comes the Sun', album: "Album name" },
        { id: 1, title: 'Song Title 1', album: "Album name" },
        { id: 1, title: 'Song Title 2', album: "Album name" },
        { id: 1, title: 'Song Title 3', album: "Album name" },
        { id: 1, title: 'Song Title 4', album: "Album name" }
      ],
      albums: [
        { name: 'Album 1' },
        { name: 'Album 2' },
        { name: 'Album 3' },
        { name: 'Album 4' },
        { name: 'Album 5' },
        { name: 'Album 6' },
        { name: 'Album 7' },
        { name: 'Album 8' },
        { name: 'Album 9' },
        { name: 'Album 10' }
      ]
    }
  }
}
</script>
