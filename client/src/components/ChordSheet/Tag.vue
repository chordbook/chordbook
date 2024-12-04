<script>
import { Tag } from "chordsheetjs";

export default {
  for: function (item) {
    return item instanceof Tag && item.value;
  },

  props: {
    item: Tag,
  },
};
</script>

<template>
  <div v-if="item.isRenderable()" :class="['tag', item.name]">
    {{ item.value }}
  </div>
</template>
