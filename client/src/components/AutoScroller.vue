<script setup>
defineProps({
  duration: {
    type: Number,
    required: true
  }
})

</script>

<template>
  <slot />
</template>
