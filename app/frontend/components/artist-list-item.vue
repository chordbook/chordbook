<template>
  <router-link
    :to="{ name: 'artist', params: { id: artist.id }}"
    class="block"
  >
    <div class="bg-white dark:bg-slate-900 shadow-md hover:shadow-lg relative overflow-hidden rounded-full">
      <canvas
        width="400"
        height="400"
      />
      <img
        v-if="artist.thumbnail"
        :src="artist.thumbnail"
        class="w-full h-full absolute inset-0"
      >
      <div
        v-else
        class="w-full h-full absolute inset-0 opacity-10 flex place-content-center items-center"
      >
        <icon-bi:person-fill class="icon-large" />
      </div>
    </div>
    <div class="mt-3 text-center">
      <h3 class="whitespace-nowrap text-sm font-bold overflow-hidden text-ellipsis">
        {{ artist.name }}
      </h3>
      <div class="text-xs opacity-70">
        Artist
      </div>
    </div>
  </router-link>
</template>

<script>
export default {
  props: {
    artist: {
      type: Object,
      required: true
    }
  }
}
</script>
