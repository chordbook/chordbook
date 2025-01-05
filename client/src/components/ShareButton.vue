<script lang="ts" setup>
import { share } from "@/icons";
import "share-api-polyfill";
import { useRouter } from "vue-router";

import type { RouteLocationRaw } from "vue-router";

const props = defineProps<{
  routerLink: RouteLocationRaw;
  title: string;
}>();

const router = useRouter();

async function doShare() {
  const data = {
    url: new URL(router.resolve(props.routerLink).href, window.location.toString()).toString(),
    title: props.title,
  };
  return navigator.share(data).catch(console.error);
}
</script>

<template>
  <IonButton @click="doShare">
    <IonIcon slot="icon-only" :icon="share" />
  </IonButton>
</template>
