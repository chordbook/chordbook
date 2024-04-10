<script setup>
defineProps({
  name: {
    type: String,
    required: true
  },
  value: {
    type: [String, Number, null],
    default: null
  }
})
</script>

<template>
  <ion-chip class="py-0">
    <div class="text-nowrap w-full inline-flex items-baseline gap-1 justify-center">
      <span class="opacity-70 uppercase text-xs">
        {{ name }}{{ value || $slots.default ? ':' : '' }}
      </span>
      <slot><strong>{{ value }}</strong></slot>
    </div>
  </ion-chip>
</template>
