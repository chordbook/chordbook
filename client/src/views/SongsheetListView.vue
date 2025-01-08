<script setup lang="ts">
import type { Songsheet } from "@/api";
import { DataSource } from "@/components";
import SongsheetItem from "@/components/SongsheetItem.vue";
import { add } from "ionicons/icons";
import LibraryPlaceholder from "../components/LibraryPlaceholder.vue";
</script>

<template>
  <AppView>
    <Head>
      <title>{{ $route.meta.title || "Songs" }}</title>
    </Head>
    <IonHeader translucent collapse="fade">
      <IonToolbar>
        <IonTitle>{{ $route.meta.title || "Songs" }}</IonTitle>

        <IonButtons slot="start">
          <IonBackButton class="md:hidden" text="" default-href="/library" />
        </IonButtons>

        <IonButtons slot="end">
          <IonButton :router-link="{ name: 'songsheet.new' }">
            <IonIcon slot="icon-only" :icon="add" />
          </IonButton>
        </IonButtons>
      </IonToolbar>
    </IonHeader>

    <IonContent fullscreen class="relative main-content">
      <IonHeader collapse="condense">
        <IonToolbar>
          <IonTitle size="large">
            {{ $route.meta.title || "Songs" }}
          </IonTitle>
        </IonToolbar>
      </IonHeader>
      <DataSource :src="$route.path">
        <template #empty>
          <LibraryPlaceholder type="song" />
        </template>
        <template #default="{ items }">
          <IonList>
            <SongsheetItem
              v-for="songsheet in items"
              :key="(songsheet as Songsheet).id"
              v-bind="songsheet as Songsheet"
            />
          </IonList>
        </template>
      </DataSource>
    </IonContent>
  </AppView>
</template>
