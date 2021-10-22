<template>
  <div class="comment">{{ item.value }}</div>
</template>

<script>
import { Tag } from "chordsheetjs"

export default {
  for: function(item) {
    return item instanceof Tag && item.name == "comment"
  },

  props: {
    item: Tag
  }
}
</script>
