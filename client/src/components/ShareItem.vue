<script lang="ts" setup>
import "share-api-polyfill";
import * as icons from "@/icons";
import { useRouter } from "vue-router";

import type { RouteLocationRaw } from "vue-router";

const props = defineProps<{
  routerLink: RouteLocationRaw
  title: string
}>();

const router = useRouter();

function share() {
  const data = {
    title: props.title,
    url: new URL(
      router.resolve(props.routerLink).href,
      window.location.toString(),
    ).toString(),
  };

  return navigator.share(data).catch(console.error);
}
</script>

<template>
  <ion-item button detail :detail-icon="icons.share" @click="share">
    <ion-label>Share</ion-label>
  </ion-item>
</template>
