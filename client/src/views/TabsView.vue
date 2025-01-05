<script setup lang="ts">
import { home, library, search } from "@/icons";
</script>

<template>
  <IonPage>
    <IonTabs>
      <IonRouterOutlet />
      <IonTabBar slot="bottom" translucent class="lg:hidden">
        <IonTabButton tab="home" href="/home">
          <IonIcon :icon="home" />
          <IonLabel>Home</IonLabel>
        </IonTabButton>

        <IonTabButton tab="discover" href="/discover">
          <IonIcon :icon="search" />
          <IonLabel>Discover</IonLabel>
        </IonTabButton>

        <IonTabButton tab="library" href="/library">
          <IonIcon :icon="library" />
          <IonLabel>Library</IonLabel>
        </IonTabButton>
      </IonTabBar>
    </IonTabs>
  </IonPage>
</template>
