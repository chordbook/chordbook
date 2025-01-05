<script lang="ts" setup>
/// <reference types="@types/dom-chromium-installation-events" />
/// <reference types="vite-plugin-pwa/client" />

import { offline } from "@/icons";
import { UseOnline } from "@vueuse/components";
import { useTimeout } from "@vueuse/core";
import { registerSW } from "virtual:pwa-register";
import { computed, ref } from "vue";

const offlineReady = ref(false);
const installPrompt = ref<BeforeInstallPromptEvent | null>(null);
const showInstallPrompt = computed(() => {
  return installPrompt.value && useTimeout(60 * 1000); // 60 second delay
});

console.info("PWA enabled, registering service worker...");
registerSW({
  immediate: true,
  onOfflineReady() {
    offlineReady.value = true;
  },
});

// Save prompt for installing to home screen
// https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps/Add_to_home_screen
window.addEventListener("beforeinstallprompt", (e: BeforeInstallPromptEvent) => {
  // Stash the event so it can be triggered later.
  installPrompt.value = e;
  console.debug("PWA: saved install prompt");
});

function addToHomeScreen() {
  // Show the prompt
  installPrompt.value?.prompt();

  // Wait for the user to respond to the prompt
  installPrompt.value?.userChoice.then((choiceResult) => {
    console.log("Response to A2HS prompt", choiceResult);
    installPrompt.value = null;
  });
}
</script>

<template>
  <IonToast
    :is-open="offlineReady"
    message="Ready to work offline."
    duration="3000"
    :buttons="[{ text: 'Ok', role: 'cancel' }]"
  />
  <IonToast
    :is-open="showInstallPrompt"
    message="Add to home screen?"
    :buttons="[
      { text: 'Not Now', role: 'cancel' },
      { text: 'Add', handler: addToHomeScreen },
    ]"
    :duration="5000"
  />
  <UseOnline v-slot="{ isOnline }">
    <IonToast
      :is-open="!isOnline"
      :icon="offline"
      header="It looks like you are offline"
      message="Some functionality will be limited."
      duration="5000"
      :buttons="[{ text: 'Ok', role: 'cancel' }]"
    />
  </UseOnline>
</template>
