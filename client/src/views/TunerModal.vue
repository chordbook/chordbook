<script setup lang="ts">
import Tuner from "@/components/Tuner.vue";
</script>

<template>
  <IonModal>
    <Head>Tuner</Head>
    <IonHeader translucent>
      <IonToolbar>
        <IonButtons slot="start">
          <IonBackButton text="" default-href="/" />
        </IonButtons>
        <IonTitle>Tuner</IonTitle>
      </IonToolbar>
    </IonHeader>

    <div class="flex place-content-center p-10">
      <Tuner />
    </div>
  </IonModal>
</template>

<style scoped>
ion-modal {
  --height: auto;
}
</style>
