<script lang="ts" setup>
import ErrorMessage from "@/components/ErrorMessage.vue";
import OfflineMessage from "@/components/OfflineMessage.vue";
import { useOnline } from "@vueuse/core";
import { onErrorCaptured, ref, watch } from "vue";

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
  <IonPage>
    <ErrorMessage v-if="error && online" :error="error" @did-dismiss="error = null" />

    <OfflineMessage v-if="error && !online" />
    <Loading v-else>
      <slot />
    </Loading>
  </IonPage>
</template>
