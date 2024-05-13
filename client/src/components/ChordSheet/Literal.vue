<script>
import { Literal } from "chordsheetjs";

export default {
  for: function (item) {
    return item instanceof Literal;
  },

  props: {
    item: Literal,
  },
};
</script>
<template>
  <div class="literal">
    {{ item.string }}
  </div>
</template>
