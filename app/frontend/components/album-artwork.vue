<template>
  <div class="bg-slate-100 dark:bg-slate-900 border border-slate-400/40 dark:border-slate-800/40 transition-shadow shadow-md hover:shadow-lg relative">
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
