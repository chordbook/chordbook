<template>
  <div class="flex gap-4">
    <div class="w-12 h-12">
      <album-artwork
        :src="album?.thumbnail"
        class="shadow-sm hover:shadow-lg"
      />
    </div>
    <div>
      <div>{{ title }}</div>
      <router-link
        :to="{ name: 'album', params: { id: album.id } }"
        class="text-sm opacity-50"
      >
        {{ album.title }}
      </router-link>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    title: {
      type: String,
      required: true
    },
    album: {
      type: Object,
      default: null
    }
  }
}
</script>
