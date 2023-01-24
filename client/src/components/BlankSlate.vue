<script setup>
import * as icons from '@/icons'

defineProps({
  icon: {
    type: String,
    required: true
  },
  title: {
    type: String,
    required: true
  },
  description: {
    type: String,
    default () { return '' }
  }
})
</script>

<template>
  <div class="flex flex-col justify-center items-center text-center min-h-screen-2/3 my-auto text-muted">
    <ion-icon
      :icon="icons[icon]"
      class="text-4xl"
    />
    <h2 class="bold text-3xl m-2">
      {{ title }}
    </h2>
    <p>
      {{ description }}
    </p>
  </div>
</template>
