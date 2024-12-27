<script lang="ts" setup>
import { ref, onErrorCaptured, watch } from "vue";
import { useOnline } from "@vueuse/core";
import ErrorMessage from "@/components/ErrorMessage.vue";
import OfflineMessage from "@/components/OfflineMessage.vue";

const online = useOnline();
const error = ref<unknown>(null);

onErrorCaptured((err) => {
  error.value = err;
});

// Clear error to try again when internet connection restored
watch(online, (online) => {
  if (online) error.value = null;
});
</script>

<template>
  <ion-page>
    <error-message
      v-if="error && online"
      :error="error"
      @did-dismiss="error = null"
    />

    <OfflineMessage v-if="error && !online" />
    <loading v-else>
      <slot />
    </loading>
  </ion-page>
</template>
