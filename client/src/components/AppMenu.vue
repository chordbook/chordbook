<script lang="ts" setup>
import * as icons from "@/icons";
import useAuthStore from "@/stores/auth";
import { ref, watch } from "vue";
import { useRoute } from "vue-router";

const auth = useAuthStore();
const route = useRoute();
const selected = ref("discover");

watch(route, () => (selected.value = (route.meta?.selected as string) || selected.value), {
  immediate: true,
});

function colorFor(item: string) {
  return item === selected.value ? "primary" : "";
}
</script>

<template>
  <IonMenu>
    <IonHeader translucent>
      <IonToolbar>
        <IonButtons slot="start">
          <IonMenuButton />
        </IonButtons>
      </IonToolbar>
    </IonHeader>
    <IonContent fullscreen class="ion-padding-horizontal">
      <div class="flex h-full flex-col">
        <IonList lines="none" class="py-4">
          <IonMenuToggle auto-hide="false">
            <IonItem
              button
              :router-link="{ name: 'home' }"
              router-direction="root"
              :detail="false"
              :color="colorFor('home')"
            >
              <IonIcon slot="start" size="small" :icon="icons.home" />
              <IonLabel>Home</IonLabel>
            </IonItem>
            <IonItem
              button
              :router-link="{ name: 'discover' }"
              router-direction="root"
              :detail="false"
              :color="colorFor('discover')"
            >
              <IonIcon slot="start" size="small" :icon="icons.search" />
              <IonLabel>Discover</IonLabel>
            </IonItem>
          </IonMenuToggle>
        </IonList>

        <IonList lines="none">
          <IonListHeader lines="none"> Library </IonListHeader>
          <IonMenuToggle auto-hide="false">
            <IonItem
              button
              router-link="/songsheets"
              router-direction="root"
              :detail="false"
              :color="colorFor('songs')"
            >
              <IonIcon slot="start" size="small" :icon="icons.song" />
              Songs
            </IonItem>
            <IonItem
              button
              router-link="/artists"
              router-direction="root"
              :detail="false"
              :color="colorFor('artists')"
            >
              <IonIcon slot="start" size="small" :icon="icons.artist" />
              Artists
            </IonItem>
            <IonItem
              button
              router-link="/albums"
              router-direction="root"
              :detail="false"
              :color="colorFor('albums')"
            >
              <IonIcon slot="start" size="small" :icon="icons.album" />
              Albums
            </IonItem>
            <IonItem
              button
              router-link="/setlists"
              router-direction="root"
              :detail="false"
              :color="colorFor('setlists')"
            >
              <IonIcon slot="start" size="small" :icon="icons.setlist" />
              Setlists
            </IonItem>
          </IonMenuToggle>
        </IonList>

        <IonList lines="none" class="mt-auto mb-3">
          <IonMenuToggle auto-hide="false">
            <IonItem
              button
              :router-link="{ name: 'news' }"
              router-direction="root"
              :detail="false"
              :color="colorFor('news')"
            >
              <IonIcon slot="start" size="small" :icon="icons.news" />
              What's New
            </IonItem>
            <IonItem button router-link="#chords" router-direction="root" :detail="false">
              <IonIcon slot="start" size="small" :icon="icons.chordDiagram" />
              Chords
            </IonItem>
            <IonItem button router-link="#tuner" router-direction="root" :detail="false">
              <IonIcon slot="start" size="small" :icon="icons.tuningFork" />
              Tuner
            </IonItem>
            <IonButton
              v-if="!auth.isAuthenticated"
              class="block"
              color="primary"
              fill="outline"
              router-link="#signin"
            >
              <IonIcon slot="start" size="small" :icon="icons.signin" />
              Sign In
            </IonButton>
          </IonMenuToggle>
        </IonList>
      </div>
    </IonContent>
  </IonMenu>
</template>

<style scoped>
ion-menu {
  @apply border-r dark:border-slate-900;
}

.ios ion-item {
  @apply rounded-lg;
}
</style>
