<script setup lang="ts">
import type { Album } from "@/api";
import AlbumItem from "@/components/AlbumItem.vue";
import LibraryPlaceholder from "@/components/LibraryPlaceholder.vue";
</script>

<template>
  <AppView>
    <Head>
      <title>Albums</title>
    </Head>
    <IonHeader translucent collapse="fade">
      <IonToolbar>
        <IonButtons slot="start">
          <IonBackButton
            class="md:hidden"
            text=""
            :default-href="$route.path.replace('/albums', '')"
          />
        </IonButtons>
        <IonTitle>Albums</IonTitle>
      </IonToolbar>
    </IonHeader>

    <IonContent fullscreen class="main-content">
      <IonHeader collapse="condense">
        <IonToolbar>
          <IonTitle size="large"> Albums </IonTitle>
        </IonToolbar>
      </IonHeader>
      <DataSource :src="$route.path" :params="$route.params">
        <template #empty>
          <LibraryPlaceholder type="album" />
        </template>
        <template #default="{ items }: { items: Album[] }">
          <IonList>
            <div
              class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 2xl:grid-cols-8"
            >
              <AlbumItem v-for="album in items" :key="album.id" v-bind="album" />
            </div>
          </IonList>
        </template>
      </DataSource>
    </IonContent>
  </AppView>
</template>
