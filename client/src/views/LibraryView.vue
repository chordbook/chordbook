<script setup lang="ts">
import * as icons from "@/icons";
</script>

<template>
  <AppView>
    <Head>
      <title>Library</title>
    </Head>
    <IonHeader translucent>
      <IonToolbar>
        <IonButtons slot="start">
          <IonMenuButton />
        </IonButtons>
        <IonTitle>Library</IonTitle>
        <IonButtons slot="end">
          <IonButton router-link="/account">
            <IonIcon slot="icon-only" :icon="icons.avatar" />
          </IonButton>
        </IonButtons>
      </IonToolbar>
    </IonHeader>

    <IonContent fullscreen class="main-content">
      <IonHeader collapse="condense">
        <IonToolbar>
          <IonTitle size="large"> Library </IonTitle>
        </IonToolbar>
      </IonHeader>

      <IonList>
        <IonItem button router-link="/songsheets">
          <IonIcon slot="start" size="small" :icon="icons.song" />
          <IonLabel>Songs</IonLabel>
        </IonItem>
        <IonItem button router-link="/artists">
          <IonIcon slot="start" size="small" :icon="icons.artist" />
          <IonLabel>Artists</IonLabel>
        </IonItem>
        <IonItem button router-link="/setlists">
          <IonIcon slot="start" size="small" :icon="icons.setlist" />
          <IonLabel>Setlists</IonLabel>
        </IonItem>
      </IonList>
    </IonContent>
  </AppView>
</template>
