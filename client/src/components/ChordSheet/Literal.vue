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
  <pre class="literal">{{ item.string }}</pre>
</template>

<style scoped>
.literal {
  @apply font-mono text-rel-xs text-slate-600 dark:text-slate-400;
}
</style>
