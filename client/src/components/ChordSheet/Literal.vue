<script lang="ts">
import { Literal } from "chordsheetjs";

export default {
  for: function (item: unknown): item is Literal {
    return item instanceof Literal;
  }
};
</script>

<script lang="ts" setup>
defineProps<{
  item: Literal
}>();
</script>
<template>
  <div class="literal">
    {{ item.string }}
  </div>
</template>
