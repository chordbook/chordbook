<script setup lang="ts">
import * as icons from "@/icons";
import useAuthStore from "@/stores/auth";

const auth = useAuthStore();
</script>

<template>
  <AppView>
    <Head>
      <title>Account</title>
    </Head>
    <IonHeader>
      <IonToolbar>
        <IonButtons slot="start">
          <IonBackButton text="" default-href="/home" />
        </IonButtons>
        <IonTitle>Account</IonTitle>
      </IonToolbar>
      <IonContent fullscreen>
        <IonList>
          <IonItem class="item-label-stacked">
            <IonLabel position="stacked"> Name </IonLabel>
            <IonLabel>{{ auth.user.name }}</IonLabel>
          </IonItem>
          <IonItem class="item-label-stacked">
            <IonLabel position="stacked"> Email </IonLabel>
            <IonLabel>{{ auth.user.email }}</IonLabel>
          </IonItem>
        </IonList>
        <div class="ion-padding">
          <IonButton class="mx-auto" color="medium" fill="outline" @click="auth.signOut">
            <IonIcon slot="start" :icon="icons.signout" />
            Sign Out
          </IonButton>
        </div>
      </IonContent>
    </IonHeader>
  </AppView>
</template>
