<script setup>
import { ref, onErrorCaptured, watch } from 'vue'
import { useOnline } from '@vueuse/core'

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
        <blank-slate
          v-if="online"
          icon="warning"
          title="Something went wrong"
          description="An unexpected error occurred."
        />
        <blank-slate
          v-else
          icon="offline"
          title="Not available offline"
          description="Try again when you are online and it will be available offline next time."
        />
      </ion-content>
    </template>
    <loading v-else>
      <slot />
    </loading>
  </ion-page>
</template>
