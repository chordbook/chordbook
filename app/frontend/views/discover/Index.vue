<template>
  <div class="p-8">
    <div class="w-80 mb-6">
      <div class="inline-flex w-full items-center px-3 rounded-full relative transition duration-300 ring-2 ring-sky-800 focus-within:ring-sky-500">
        <label for="search-input">
          <icon-bi:search class="icon-small opacity-50" />
        </label>
        <input
          id="search-input"
          v-model="query"
          type="search"
          placeholder="Search…"
          class="bg-transparent border-none focus:ring-0 w-full"
          @keyup.enter="search"
          @keyup.escape="clear"
        >
        <button
          v-if="query"
          @click="clear"
        >
          <icon-bi:x class="opacity-50" />
        </button>
      </div>
    </div>

    <router-view
      name="search"
      v-bind="$route.query"
    />

    <router-view
      v-if="!query"
      name="browse"
    />
  </div>
</template>

<script>
/* eslint-disable vue/no-mutating-props */
import { useDebounceFn } from '@vueuse/core'

export default {
  props: {
    q: {
      type: String,
      default: ''
    }
  },

  data() {
    return { query: '' }
  },

  watch: {
    $route: 'updateFromRoute',
    query: 'search'
  },

  created () {
    this.updateFromRoute()
  },

  methods: {
    updateFromRoute () {
      const q = this.$route.query.q
      console.log('Updating', { q })
      if (q) this.query = q
    },

    clear () {
      this.query = ''
    },

    search: useDebounceFn(function () {
      if (this.query === undefined) return

      this.$router.push({
        name: 'discover',
        query: Object.assign(
          {},
          this.$route.query,
          { q: this.query }
        ),
        replace: this.$route.name === 'discover'
      })
    }, 500, { maxWait: 2000 })
  }
}
</script>
