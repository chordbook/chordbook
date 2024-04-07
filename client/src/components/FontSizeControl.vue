<script setup>
import { useThemeStore } from '@/stores'
import { textOutline } from 'ionicons/icons'

const theme = useThemeStore()
</script>

<template>
  <ion-button @click="theme.decreaseFontSize()">
    <ion-icon
      :icon="textOutline"
      class="text-base mt-1"
    />
  </ion-button>
  <ion-button @click="theme.increaseFontSize()">
    <ion-icon :icon="textOutline" />
  </ion-button>
</template>
