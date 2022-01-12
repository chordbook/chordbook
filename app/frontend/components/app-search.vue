<template>
  <label class="inline-flex items-center px-3 bg-slate-800 border-black/50 rounded-full relative focus-within:ring-2 ring-blue-500">
    <icon-bi:search class="icon-small opacity-50" />

    <input
      v-model="q"
      type="search"
      class="bg-transparent border-none focus:ring-0"
      @keyup.enter="search"
    >
  </label>
</template>

<script>
export default {
  data () {
    return {
      q: this.$route.params.q
    }
  },

  watch: {
    q: 'search'
  },

  methods: {
    search () {
      this.$router.push({
        name: 'search',
        query: Object.assign(
          {},
          this.$route.query,
          { q: this.q }
        )
      })
    }
  }
}
</script>
