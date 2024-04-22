<script setup>
import ModelComponent from './ModelComponent.vue'
import HorizontalScroller from './HorizontalScroller.vue'

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
</script>

<template>
  <HorizontalScroller
    :class="{
      'grid-scroll-x touch:[--auto-cols-peek:0.9]': true,
      'grid-rows-3 auto-cols-1/1 sm:auto-cols-1/2 lg:auto-cols-1/3 2xl:auto-cols-1/4': props.format === 'item',
      'auto-cols-1/2 sm:auto-cols-1/3 md:auto-cols-1/4 lg:auto-cols-1/5 xl:auto-cols-1/6 2xl:auto-cols-1/8': props.format === 'card'
    }"
  >
    <model-component
      v-for="item in props.items"
      :key="item.id"
      :format="format"
      v-bind="{ ...item, ...$attrs }"
    />
  </HorizontalScroller>
</template>
