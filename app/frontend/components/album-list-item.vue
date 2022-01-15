<template>
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
        <span v-if="show == 'released'">{{ album.released }}</span>
        <span v-else>{{ album.artist.name }}</span>
      </div>
    </div>
  </router-link>
</template>

<script>
export default {
  props: {
    album: {
      type: Object,
      required: true
    },

    show: {
      type: String,
      default: 'released' // or 'artist'
    }
  }
}
</script>
