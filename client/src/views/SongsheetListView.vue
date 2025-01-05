<script setup lang="ts">
import type { Songsheet } from "@/api";
import { DataSource } from "@/components";
import SongsheetItem from "@/components/SongsheetItem.vue";
import { add } from "ionicons/icons";
import { useTemplateRef } from "vue";
import LibraryPlaceholder from "../components/LibraryPlaceholder.vue";

const dataSource = useTemplateRef("dataSource");
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
        v-if="dataSource"
        slot="fixed"
        @ion-refresh="dataSource?.reload().then(() => $event.target.complete())"
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
      <DataSource ref="dataSource" :src="$route.path">
        <template #empty>
          <library-placeholder type="song" />
        </template>
        <template #default="{ items }">
          <ion-list>
            <songsheet-item
              v-for="songsheet in items"
              :key="(songsheet as Songsheet).id"
              v-bind="songsheet as Songsheet"
            />
          </ion-list>
        </template>
      </DataSource>
    </ion-content>
  </app-view>
</template>
