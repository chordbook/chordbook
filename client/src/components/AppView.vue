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
    <template v-if="error">
      <ion-header translucent>
        <ion-toolbar>
          <ion-buttons slot="start">
            <ion-back-button
              text=""
              default-href="/"
            />
          </ion-buttons>
        </ion-toolbar>
      </ion-header>
      <ion-content>
        <div class="flex flex-col justify-center items-center text-center min-h-screen py-8 text-muted">
          <div v-if="online">
            <ion-icon
              :icon="warning"
              class="text-4xl"
            />
            <h2 class="bold text-3xl m-2">
              Something went wrong
            </h2>
            <p>
              An unexpected error occurred.
            </p>
          </div>
          <div v-else>
            <ion-icon
              :icon="offline"
              class="text-4xl"
            />
            <h2 class="text-3xl m-2">
              Not available offline
            </h2>
            <p>Try again when you are online and it will be available offline next time.</p>
          </div>

          <ion-back-button
            class="m-2 text-sm"
            icon=""
            text="Go Back"
            type="reset"
            default-href="/"
            color="primary"
          />
        </div>
      </ion-content>
    </template>
    <loading v-else>
      <slot />
    </loading>
  </ion-page>
</template>
