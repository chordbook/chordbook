<template>
  <ion-page>
    <ion-header>
      <ion-toolbar>
        <ion-title>Home</ion-title>
      </ion-toolbar>
    </ion-header>
    <ion-content :fullscreen="true">
      <ion-header collapse="condense">
        <ion-toolbar>
          <ion-title size="large">
            Home
          </ion-title>
        </ion-toolbar>
      </ion-header>

      <span class="ion-padding">FIXME: find a better spot for this:</span>
      <ion-list>
        <ion-item :router-link="{ name: 'tuner' }">
          Tuner
        </ion-item>
      </ion-list>
    </ion-content>
  </ion-page>
</template>

<script>
import { IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonList, IonItem } from '@ionic/vue'

export default {
  components: { IonHeader, IonToolbar, IonTitle, IonContent, IonPage, IonList, IonItem }
}
</script>
