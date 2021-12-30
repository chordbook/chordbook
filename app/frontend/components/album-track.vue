<template>
  <div class="flex gap-4">
    <div class="relative bg-black">
      <canvas
        width="40"
        height="40"
      />
      <img
        v-if="thumbnail"
        :src="thumbnail"
        class="absolute inset-0 w-full h-full"
      >
    </div>
    <div>
      <div>{{ title }}</div>
      <div class="text-sm opacity-50">
        {{ album }}
      </div>
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
    artist: {
      type: String,
      required: true
    },
    album: {
      type: String,
      default: null
    },
    thumbnail: {
      type: String,
      default: null
    }
  }
}
</script>
