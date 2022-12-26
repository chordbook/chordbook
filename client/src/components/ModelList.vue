<script setup>
import { computed } from 'vue'
import ModelComponent from './ModelComponent.vue'

const props = defineProps({
  items: {
    type: Array,
    required: true
  },
  format: {
    type: String,
    default: 'item'
  }
})

const classes = computed(() => {
  const styles = {
    item: `grid-scroll-x grid-rows-3 auto-cols-1/1 sm:auto-cols-1/2 lg:auto-cols-1/3 2xl:auto-cols-1/4`,
    card: 'grid-scroll-x auto-cols-1/2 sm:auto-cols-1/3 md:auto-cols-1/4 lg:auto-cols-1/5 xl:auto-cols-1/6 2xl:auto-cols-1/8'
  }
  return styles[props.format]
})
</script>

<template>
  <div :class="classes">
    <model-component
      v-for="item in props.items"
      :key="item.id"
      :format="format"
      v-bind="{ ...item, ...$attrs }"
    />
  </div>
</template>
