<script lang="ts" setup>
defineProps<{
  chord: string;
}>();
</script>

<template>
  <svg
    class="chord-diagram inline-block"
    xmlns="http://www.w3.org/2000/svg"
    role="image"
    :title="chord"
  >
    <use :xlink:href="`#chord-${chord}`" />
  </svg>
</template>
