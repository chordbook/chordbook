<script setup lang="ts">
import Tuner from "@/components/Tuner.vue";
</script>

<template>
  <ion-modal>
    <Head>Tuner</Head>
    <ion-header translucent>
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button text="" default-href="/" />
        </ion-buttons>
        <ion-title>Tuner</ion-title>
      </ion-toolbar>
    </ion-header>

    <div class="flex place-content-center p-10">
      <tuner />
    </div>
  </ion-modal>
</template>

<style scoped>
ion-modal {
  --height: auto;
}
</style>
