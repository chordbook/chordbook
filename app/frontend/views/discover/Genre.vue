<template>
  <div
    v-if="genre.name"
    class="bg-white dark:bg-slate-800 min-h-full"
  >
    <div
      class="bg-black relative"
      :style="style"
    >
      <div class="relative max-w-8xl mx-auto p-4 md:p-6 lg:px-8 h-full min-h-screen-1/4 flex flex-col place-content-end text-white text-shadow-md">
        <div class="text-sm uppercase opacity-75">
          Genre
        </div>
        <h1 class="text-5xl font-bold">
          {{ genre.name }}
        </h1>
      </div>
    </div>

    <div class="max-w-8xl mx-auto p-4 md:p-6 lg:px-8">
      <h2 class="text-2xl mb-3">
        Top Songs
      </h2>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6 mb-12">
        <album-track
          v-for="track in genre?.tracks"
          :key="track.id"
          v-bind="track"
        />
      </div>

      <h2 class="text-2xl mb-3">
        Top Artists
      </h2>
      <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 xl:grid-cols-6 gap-12">
        <artist-list-item
          v-for="artist in genre?.artists"
          :key="artist.id"
          :artist="artist"
          class="my-3"
        />
      </div>
    </div>
  </div>
</template>

<script>
import api from '~/api'
import { gradient } from '~/lib/gradient'

export default {
  async beforeRouteEnter (to, from, next) {
    return api.get(`/api/genres/${to.params.id}.json`).then(response => {
      next(vm => { vm.genre = response.data })
    }).catch(() => {
      next({ name: '404' })
    })
  },

  data () {
    return {
      genre: {}
    }
  },

  computed: {
    style () {
      return `background-image: ${gradient(this.genre.name, { colors: 4, spin: 22.5 })};`
    }
  }
}
</script>
