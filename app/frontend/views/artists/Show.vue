<template>
  <div class="bg-white dark:bg-slate-800 min-h-full">
    <div
      class="bg-black relative bg-center bg-cover bg-fixed"
      :style="`background-image: url(${artist.banner});`"
    >
      <div class="absolute inset-0 bg-blend-screen opacity-80 bg-gradient-to-b to-black from-transparent" />
      <div class="relative max-w-8xl mx-auto p-4 md:p-6 lg:px-8 h-full min-h-screen-3/4 flex flex-col place-content-end text-white text-shadow-md">
        <h1 class="text-5xl font-bold">
          {{ artist.name }}
        </h1>
        <div class="opacity-60">
          <router-link
            v-if="artist.genre"
            :to="{ name: 'genre', params: { id: artist.genre.id } }"
          >
            {{ artist.genre.name }}
          </router-link>
        </div>
      </div>
    </div>

    <div class="max-w-8xl mx-auto p-4 md:p-6 lg:px-8">
      <p
        class="my-4 text-sm line-clamp-3"
        onclick="this.classList.toggle('line-clamp-3')"
      >
        {{ artist.biography }}
      </p>

      <div
        v-if="albums.length > 0"
        class="my-6"
      >
        <h2 class="text-2xl mb-3">
          Albums
        </h2>

        <div class="relative -mx-8 group">
          <div class="flex flex-no-wrap overflow-x-scroll scrolling-touch mb-8 gap-8 overscroll-x-contain pb-4 px-8">
            <album-list-item
              v-for="album in albums"
              :key="album.id"
              :album="album"
              class="flex-none w-1/6"
            />
          </div>
        </div>
      </div>
      <div
        v-if="songsheets.length > 0"
        class="my-6"
      >
        <h2 class="text-2xl mb-3">
          Popular Songsheets
        </h2>

        <ul>
          <songsheet-list-item
            v-for="songsheet in songsheets"
            :key="songsheet.id"
            :songsheet="songsheet"
            class="my-3"
          />
        </ul>
      </div>
      <div class="my-6">
        <h2 class="text-2xl mb-3">
          Popular Songs
        </h2>

        <div class="columns-4">
          <album-track
            v-for="track in tracks"
            :key="track.id"
            v-bind="track"
            class="my-3"
          />
        </div>
      </div>

      <div class="grid gap-8 grid-cols-2">
        <div
          v-for="src in images"
          :key="src"
        >
          <img :src="src">
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import api from '~/client'

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

        api.get(`/api/artists/${to.params.id}/songsheets.json`).then(response => {
          vm.songsheets = response.data
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
      albums: [],
      songsheets: []
    }
  },

  computed: {
    metadata () {
      return this.artist?.metadata || {}
    },

    images () {
      if (!this.artist.metadata) return []
      return ['', 2, 3, 4].map(i => this.artist?.metadata[`strArtistFanart${i}`]).filter(Boolean)
    }
  }
}
</script>
