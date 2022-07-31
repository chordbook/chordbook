<script setup>
import ModelComponent from './ModelComponent.vue'

const props = defineProps({
  items: {
    type: Array,
    required: true
  }
})
</script>

<template>
  <div class="grid-scroll-x grid-rows-3 auto-cols-1/1 sm:auto-cols-1/2 lg:auto-cols-1/3 2xl:auto-cols-1/4">
    <model-component
      v-for="item in props.items"
      :key="item.id"
      v-bind="{ ...item, ...$attrs }"
    />
  </div>
</template>
