<script lang="ts" setup>
import { nextTick, ref, watch } from "vue";

const { enabled = false } = defineProps<{ enabled?: boolean }>();

const content = ref();
const columnWidth = ref("auto");
const updating = ref(false);

// Calculate column width based on content width
async function updateColumnWidth() {
  if (!enabled) return;

  updating.value = true;

  // Wait for element to update before getting width
  await nextTick();

  columnWidth.value = content.value.offsetWidth + "px";
  updating.value = false;
}

watch([content, () => enabled], () => requestAnimationFrame(updateColumnWidth));
</script>

<template>
  <div ref="content" :class="{ columns: enabled && !updating, 'content-width': updating }">
    <slot />
  </div>
</template>

<style scoped>
.columns:not(.updating) {
  @apply h-full;
  column-count: auto;
  column-width: v-bind(columnWidth);
  overflow: visible;
  column-gap: 2rem;
}

/* This forces the element to be the width of its content, which is then used as the column width */
.content-width {
  max-width: max-content !important;
  min-width: max-content !important;
  width: max-content !important;
  display: inline-block !important;
  flex-wrap: nowrap !important;
  padding: 0 !important;
}

.updating * {
  flex-wrap: nowrap !important;
}
</style>
