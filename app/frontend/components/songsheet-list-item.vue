<template>
  <router-link
    :to="{ name: 'songsheet', params: { id: songsheet.id } }"
    class="flex gap-4 group my-3"
  >
    <div class="w-12 h-12">
      <album-artwork
        :src="songsheet.track?.album?.thumbnail"
        class="shadow-sm hover:shadow-lg"
      />
    </div>
    <div>
      <div>{{ songsheet.title }}</div>
      <div class="text-sm opacity-50">
        <span v-if="songsheet.artists">
          {{ new Intl.ListFormat().format(songsheet.artists.map(a => a.name)) }}
        </span>
        <span v-else>{{ songsheet.metadata?.subtitle }}</span>
      </div>
    </div>
  </router-link>
</template>

<script>
export default {
  props: {
    songsheet: {
      type: Object,
      required: true
    }
  }
}
</script>
