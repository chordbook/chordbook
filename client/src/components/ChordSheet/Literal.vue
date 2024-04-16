<script>
import { Literal } from 'chordsheetjs'

export default {
  for: function (item) {
    return item instanceof Literal
  },

  props: {
    item: Literal
  }
}
</script>
<template>
  <div class="literal">{{ item.string }}</div>
</template>

<style scoped>
.literal {
  @apply font-mono text-rel-2xs md:text-rel-xs text-slate-600 dark:text-slate-400;
}
</style>
