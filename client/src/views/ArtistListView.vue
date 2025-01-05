<script setup lang="ts">
import ArtistItem from "@/components/ArtistItem.vue";
import LibraryPlaceholder from "@/components/LibraryPlaceholder.vue";

import type { Artist } from "@/api";
</script>

<template>
  <AppView>
    <Head>
      <title>Artists</title>
    </Head>
    <IonHeader translucent>
      <IonToolbar>
        <IonTitle>Artists</IonTitle>

        <IonButtons slot="start">
          <IonBackButton
            class="md:hidden"
            text=""
            :default-href="$route.path.replace('/artists', '') || '/library'"
          />
        </IonButtons>
      </IonToolbar>
    </IonHeader>

    <IonContent fullscreen class="main-content">
      <IonHeader collapse="condense">
        <IonToolbar>
          <IonTitle size="large"> Artists </IonTitle>
        </IonToolbar>
      </IonHeader>
      <DataSource :src="$route.path" :params="$route.query">
        <template #empty>
          <LibraryPlaceholder type="artist" />
        </template>
        <template #default="{ items }: { items: Artist[] }">
          <IonList>
            <ArtistItem v-for="artist in items" :key="artist.id" v-bind="artist" />
          </IonList>
        </template>
      </DataSource>
    </IonContent>
  </AppView>
</template>
