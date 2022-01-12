<template>
  <div class="max-w-xl mx-auto py-12">
    <ul class="flex place-content-center mb-10 gap-2">
      <li
        v-for="id, name in types"
        :key="id"
      >
        <router-link
          :to="{ query: { ...$route.query, type: id } }"
          :class="{
            'text-white bg-slate-500': id === type,
            'text-slate-400 bg-slate-200 hover:bg-slate-300 dark:bg-slate-600': id !== type,
            'uppercase rounded flex place-content-center place-items-center text-xs px-2 py-1': true
          }"
        >
          {{ name }}
        </router-link>
      </li>
    </ul>

    <div class="">
      <ul>
        <li
          v-for="result in results"
          :key="result.type + result.id"
        >
          <router-link
            :to="{ name: result.type.toLowerCase(), params: { id: result.id } }"
            class="flex gap-4 border-b py-6 border-slate-500/30"
          >
            <div class="w-16">
              <!-- FIXME: show artist thumbnail -->
              <album-artwork :src="result.thumbnail" />
            </div>
            <div>
              <div class="text-xs opacity-50 uppercase">
                {{ result.type }}
              </div>
              <div class=" truncate">
                {{ result.title }}
              </div>
              <div class="text-sm opacity-75">
                {{ result.subtitle }}
              </div>
            </div>
          </router-link>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    type: {
      type: String,
      default: ''
    },
    q: {
      type: String,
      default: null
    }
  },

  data () {
    return {
      types: {
        All: '',
        Artists: 'artist',
        Albums: 'album',
        Songs: 'track,songsheet'
      },
      results: []
    }
  },

  watch: {
    q: 'update',
    type: 'update'
  },

  created () {
    this.update()
  },

  methods: {
    update () {
      this.$http.get('/api/search', { params: { q: this.q, type: this.type } }).then(response => {
        this.results = response.data
      })
    }
  }
}
</script>
