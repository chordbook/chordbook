<template>
  <div class="bg-white dark:bg-slate-800 min-h-full">
    <div
      class="bg-black relative bg-center bg-cover bg-fixed"
      :style="`background-image: url(${artist.banner});`"
    >
      <div class="absolute inset-0 bg-blend-screen opacity-80 bg-gradient-to-b to-black from-transparent" />
      <div class="relative max-w-8xl mx-auto p-4 md:p-6 lg:px-8 h-full min-h-screen-2/3 flex flex-col place-content-end text-white text-shadow-md">
        <h1 class="text-5xl font-bold">
          {{ artist.name }}
        </h1>
        <div class="opacity-60">
          {{ artist.metadata?.strStyle }}
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
          <ul class="flex flex-no-wrap overflow-x-scroll scrolling-touch mb-8 gap-8 overscroll-x-contain pb-4 px-8">
            <li
              v-for="album in albums"
              :key="album.id"
              class="flex-none w-1/6"
            >
              <router-link
                :to="{ name: 'album', params: { id: album.id } }"
                class="block"
              >
                <album-artwork :src="album.thumbnail" />
                <div class="mt-2 text-sm">
                  <div class="whitespace-nowrap overflow-hidden text-ellipsis">
                    {{ album.title }}
                  </div>
                  <div class="text-xs opacity-50">
                    {{ album.released }}
                  </div>
                </div>
              </router-link>
            </li>
            <li class="absolute top-0 bottom-0 left-0 flex flex-col place-content-center bg-gradient-to-r via-white from-white w-16 pr-4 pb-10 mb-4">
              <a
                href=""
                class="opacity-0 group-hover:opacity-50 transition ease-in-out"
              >
                <icon-bi:chevron-left />
              </a>
            </li>
            <li class="absolute top-0 bottom-0 right-0 flex flex-col place-content-center bg-gradient-to-l via-white from-white w-16 pl-4 pb-10 mb-4 text-right">
              <a
                href=""
                class="opacity-0 group-hover:opacity-50 transition ease-in-out"
              >
                <icon-bi:chevron-right />
              </a>
            </li>
          </ul>
        </div>
      </div>
      <div class="my-6">
        <h2 class="text-2xl mb-3">
          Popular Songs
        </h2>

        <album-track
          v-for="track in tracks"
          :key="track.id"
          v-bind="track"
          class="my-3"
        />

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
