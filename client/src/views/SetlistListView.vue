<script setup>
import SetlistCard from '@/components/SetlistCard.vue'
</script>

<template>
  <ion-page>
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

    <ion-content>
      <ion-header collapse="condense">
        <ion-toolbar>
          <ion-title size="large">
            Setlists
          </ion-title>
        </ion-toolbar>
      </ion-header>

      <ion-list>
        <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-4 xl:grid-cols-5 2xl:grid-cols-6">
          <data-source
            v-slot="{ items }"
            src="setlists"
            :params="$route.query"
            paginate
          >
            <setlist-card
              v-for="setlist in items"
              :key="setlist.id"
              :setlist="setlist"
            />
          </data-source>
        </div>
      </ion-list>
    </ion-content>
  </ion-page>
</template>
