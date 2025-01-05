<script setup lang="ts">
import type { Setlist } from "@/api";
import SetlistCard from "@/components/SetlistCard.vue";
import { usePaginatedFetch } from "@/composables";
import { reactive } from "vue";

const dataSource = reactive(usePaginatedFetch<Setlist>("setlists"));

// const dataSource = useTemplateRef("dataSource");
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

      <ion-refresher slot="fixed" @ion-refresh="reload">
        <ion-refresher-content />
      </ion-refresher>

      <!-- <DataSource ref="dataSource" v-slot="{ items }: { items: Setlist }" src="setlists"> -->
      <ion-list>
        <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 2xl:grid-cols-6">
          <setlist-card v-for="setlist in dataSource.items" :key="setlist.id" v-bind="setlist" />
        </div>
      </ion-list>
      <!-- </DataSource> -->
    </ion-content>
  </app-view>
</template>
