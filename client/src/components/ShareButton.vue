<script setup>
import "share-api-polyfill";
import { share } from "@/icons";
import { useRouter } from "vue-router";

const props = defineProps({
  routerLink: {
    type: [String, Object],
    required: true,
  },
  title: {
    type: String,
    required: true,
  },
});

const router = useRouter();

async function doShare() {
  const data = {
    url: new URL(
      router.resolve(props.routerLink).href,
      window.location,
    ).toString(),
    title: props.title,
  };
  return navigator.share(data).catch(console.error);
}
</script>

<template>
  <ion-button @click="doShare">
    <ion-icon slot="icon-only" :icon="share" />
  </ion-button>
</template>
