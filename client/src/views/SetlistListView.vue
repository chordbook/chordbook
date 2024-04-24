<script setup>
import SetlistCard from '@/components/SetlistCard.vue'
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
          <ion-back-button
            class="md:hidden"
            text=""
            default-href="/library"
          />
        </ion-buttons>
      </ion-toolbar>
    </ion-header>

    <ion-content
      fullscreen
      class="main-content"
    >
      <ion-header collapse="condense">
        <ion-toolbar>
          <ion-title size="large">
            Setlists
          </ion-title>
        </ion-toolbar>
      </ion-header>

      <ion-refresher
        v-if="$refs.dataSource"
        slot="fixed"
        @ion-refresh="$refs.dataSource.reload"
      >
        <ion-refresher-content />
      </ion-refresher>

      <data-source
        ref="dataSource"
        v-slot="{ items }"
        src="setlists"
        :params="$route.query"
      >
        <ion-list>
          <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 2xl:grid-cols-6">
            <setlist-card
              v-for="setlist in items"
              :key="setlist.id"
              v-bind="setlist"
            />
          </div>
        </ion-list>
      </data-source>
    </ion-content>
  </app-view>
</template>
