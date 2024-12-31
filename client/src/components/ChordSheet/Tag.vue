<script lang="ts">
import { Tag } from "chordsheetjs";

export default {
  for: function (item: unknown): item is Tag {
    return item instanceof Tag && !!item.value;
  }
};
</script>

<script lang="ts" setup>
defineProps<{ item: Tag }>();
</script>

<template>
  <div :class="['tag', item.name]">
    {{ item.value }}
  </div>
</template>
