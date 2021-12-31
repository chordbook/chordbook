<template>
  <div class="bg-slate-100 dark:bg-slate-900 transition-shadow shadow-lg hover:shadow-xl rounded relative overflow-hidden">
    <canvas
      width="600"
      height="600"
    />
    <img
      v-if="src"
      :src="src"
      class="absolute inset-0 w-full h-full"
    >
  </div>
</template>

<script>
export default {
  props: {
    src: {
      type: [String, null],
      default: null
    }
  }
}
</script>
