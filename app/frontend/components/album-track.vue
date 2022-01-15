<template>
  <router-link
    :to="{ name: 'track', params: { id } }"
    class="flex gap-4"
  >
    <div class="w-12 h-12 flex-none">
      <album-artwork
        :src="album?.thumbnail"
        class="shadow-sm hover:shadow-lg"
      />
    </div>
    <div class="overflow-hidden">
      <div class="truncate">
        {{ title }}
      </div>
      <router-link
        :to="{ name: 'album', params: { id: album.id } }"
        class="block truncate text-sm opacity-50"
      >
        {{ album.title }}
      </router-link>
    </div>
  </router-link>
</template>

<script>
export default {
  props: {
    id: {
      type: Number,
      required: true
    },
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
