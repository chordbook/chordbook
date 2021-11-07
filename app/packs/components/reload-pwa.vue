<script setup lang="ts">
import { useRegisterSW } from 'virtual:pwa-register/vue'

const {
  offlineReady,
  needRefresh,
  updateServiceWorker,
} = useRegisterSW()

const close = async() => {
  offlineReady.value = false
  needRefresh.value = false
}
</script>

<template>
 <div v-if="offlineReady || needRefresh" role="alert"
    class="flex flex-wrap md:flex-nowrap bg-blue-800 text-white text-sm px-6 py-2 justify-between align-middle">
    <div class="message mt-1">
      <span v-if="offlineReady"> App ready to work offline</span>
      <span v-else>
        New content available, click on reload button to update.
      </span>
    </div>
    <div class="buttons flex align-middle mt-2 md:mt-0">
      <button v-if="needRefresh" @click="updateServiceWorker()" class="btn btn-small btn-muted mr-4">
        Reload
      </button>
      <button @click="close" class="btn btn-small btn-muted">
        Close
      </button>
    </div>
  </div>
</template>
