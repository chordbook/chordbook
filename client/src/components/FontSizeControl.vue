<script setup>
import { useThemeStore } from '@/stores'
import { textOutline } from 'ionicons/icons'

const theme = useThemeStore()
</script>

<template>
  <ion-button
    v-tooltip="'Decrease font size'"
    @click="theme.decreaseFontSize()"
  >
    <ion-icon
      :icon="textOutline"
      class="text-base mt-1"
    />
  </ion-button>
  <ion-button
    v-tooltip="'Increase font size'"
    @click="theme.increaseFontSize()"
  >
    <ion-icon :icon="textOutline" />
  </ion-button>
</template>
