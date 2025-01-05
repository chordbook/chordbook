<script setup lang="ts">
import type { Setlist } from "@/api";
import { DataSource } from "@/components";
import SetlistCard from "@/components/SetlistCard.vue";
import { useTemplateRef } from "vue";

const dataSource = useTemplateRef("dataSource");
</script>

<template>
  <app-view>
    <Head>
      <title>Setlists</title>
    </Head>
    <ion-header translucent>
      <ion-toolbar>
        <ion-title>Setlists</ion-title>

        <ion-buttons slot="start">
          <ion-back-button class="md:hidden" text="" default-href="/library" />
        </ion-buttons>
      </ion-toolbar>
    </ion-header>

    <ion-content fullscreen class="main-content">
      <ion-header collapse="condense">
        <ion-toolbar>
          <ion-title size="large"> Setlists </ion-title>
        </ion-toolbar>
      </ion-header>

      <ion-refresher
        v-if="dataSource"
        slot="fixed"
        @ion-refresh="dataSource?.reload().then(() => $event.target.complete())"
      >
        <ion-refresher-content />
      </ion-refresher>

      <DataSource ref="dataSource" v-slot="{ items }" src="setlists">
        <ion-list>
          <div
            class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 2xl:grid-cols-6"
          >
            <setlist-card
              v-for="setlist in items"
              :key="(setlist as Setlist).id"
              v-bind="setlist as Setlist"
            />
          </div>
        </ion-list>
      </DataSource>
    </ion-content>
  </app-view>
</template>
