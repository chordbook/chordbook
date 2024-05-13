<script setup>
import SongsheetItem from "@/components/SongsheetItem.vue";
import LibraryPlaceholder from "../components/LibraryPlaceholder.vue";
import { add } from "ionicons/icons";
</script>

<template>
  <app-view>
    <Head>
      <title>{{ $route.meta.title || "Songs" }}</title>
    </Head>
    <ion-header translucent collapse="fade">
      <ion-toolbar>
        <ion-title>{{ $route.meta.title || "Songs" }}</ion-title>

        <ion-buttons slot="start">
          <ion-back-button class="md:hidden" text="" default-href="/library" />
        </ion-buttons>

        <ion-buttons slot="end">
          <ion-button :router-link="{ name: 'songsheet.new' }">
            <ion-icon slot="icon-only" :icon="add" />
          </ion-button>
        </ion-buttons>
      </ion-toolbar>
    </ion-header>

    <ion-content fullscreen class="relative main-content">
      <ion-refresher
        v-if="$refs.dataSource"
        slot="fixed"
        @ion-refresh="$refs.dataSource.reload"
      >
        <ion-refresher-content />
      </ion-refresher>
      <ion-header collapse="condense">
        <ion-toolbar>
          <ion-title size="large">
            {{ $route.meta.title || "Songs" }}
          </ion-title>
        </ion-toolbar>
      </ion-header>
      <data-source ref="dataSource" :src="$route.path" :params="$route.query">
        <template #empty>
          <library-placeholder type="song" />
        </template>
        <template #default="{ items }">
          <ion-list>
            <songsheet-item
              v-for="songsheet in items"
              :key="songsheet.id"
              v-bind="songsheet"
            />
          </ion-list>
        </template>
      </data-source>
    </ion-content>
  </app-view>
</template>
