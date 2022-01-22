<template>
  <div class="max-w-8xl mx-auto p-4 md:p-6 lg:p-8">
    <div class="flex gap-8">
      <div class="w-64 h-64">
        <album-artwork :src="album.thumbnail" />
      </div>
      <div class="pt-6 grow">
        <h1 class="text-4xl">
          {{ album.title }}
        </h1>
        <h2
          v-if="album.artist"
          class="text-2xl"
        >
          <router-link
            :to="{ name: 'artist', params: { id: album.artist.id }}"
            class="text-green-700"
          >
            {{ album.artist.name }}
          </router-link>
        </h2>

        <div class="text-sm opacity-60">
          {{ album.style }} • {{ album.released }}
        </div>

        <p
          class="text-sm opacity-70 line-clamp-4 mt-8 max-w-xl"
          onclick="this.classList.toggle('line-clamp-4')"
        >
          {{ album.description }}
        </p>

        <div class="mt-16">
          <ol class="max-w-xl">
            <li
              v-for="track in album.tracks"
              :key="track.id"
              :class="{ 'opacity-30': !track.has_songsheet }"
            >
              <router-link
                :to="songsheetLink(track)"
                class="px-4 -mx-4 py-2 flex items-baseline hover:bg-green-50 dark:hover:bg-green-800/50 hover:rounded"
              >
                <div class="w-8 text-sm opacity-50">
                  {{ track.number }}.
                </div>
                <div class="grow">
                  {{ track.title }}
                </div>

                <div class="w-10 text-sm opacity-50">
                  <track-duration :value="track.duration" />
                </div>
              </router-link>
            </li>
          </ol>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import api from '~/client'

export default {
  async beforeRouteEnter (to, from, next) {
    return api.get(`/api/albums/${to.params.id}.json`).then(response => {
      next(vm => { vm.album = response.data })
    }).catch(() => {
      next({ name: '404' })
    })
  },

  data () {
    return {
      album: {}
    }
  },

  methods: {
    songsheetLink (track) {
      return {
        name: track.has_songsheet ? 'track' : 'songsheet.new',
        params: { track: track.id }
      }
    }
  }
}
</script>
