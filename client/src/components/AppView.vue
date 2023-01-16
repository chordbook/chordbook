<script setup>
import { ref, onErrorCaptured, watch } from 'vue'
import { useOnline } from '@vueuse/core'
import { offline, warning } from '@/icons'

const online = useOnline()
const error = ref(null)

onErrorCaptured((err, instance, info) => {
  console.log('ERROR', err, instance, info)
  error.value = err
})

// Clear error to try again when internet connection restored
watch(online, (online) => {
  if (online) error.value = null
})

</script>

<template>
  <ion-page>
    <div
      v-if="error"
      class="flex flex-col justify-center items-center text-center min-h-screen py-8 text-muted"
    >
      <div v-if="online">
        <ion-icon
          :icon="warning"
          class="text-4xl"
        />
        <h2 class="bold text-3xl m-2">
          Something went wrong
        </h2>
        <p class="text-sm">
          An unexpected error occurred.
        </p>
      </div>
      <div v-else>
        <ion-icon
          :icon="offline"
          class="text-4xl"
        />
        <h2 class="text-2xl m-2">
          Not available offline
        </h2>
        <p>Load this page next time you're online and it will be available offline.</p>
      </div>
    </div>
    <loading v-else>
      <slot />
    </loading>
  </ion-page>
</template>
