<script setup>
import DataSource from '@/DataSource'
import SetlistCard from '@/components/SetlistCard.vue'
import {
  IonBackButton,
  IonButtons,
  IonContent,
  IonHeader,
  IonInfiniteScroll,
  IonInfiniteScrollContent,
  IonList,
  IonMenuToggle,
  IonPage,
  IonTitle,
  IonToolbar
} from '@ionic/vue'
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const dataSource = ref(new DataSource('/api/setlists', { params: route.query }))
onMounted(() => dataSource.value.load())
</script>

<template>
  <ion-page>
    <ion-header translucent>
      <ion-toolbar>
        <ion-title>Setlists</ion-title>

        <ion-buttons slot="start">
          <ion-menu-toggle>
            <ion-back-button
              text=""
              default-href=""
            />
          </ion-menu-toggle>
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
          <setlist-card
            v-for="setlist in dataSource.items"
            :key="setlist.id"
            :setlist="setlist"
          />
        </div>
      </ion-list>

      <ion-infinite-scroll
        threshold="500px"
        :disabled="dataSource.loading || dataSource.disabled"
        @ion-infinite="dataSource.load().then(() => $event.target.complete())"
      >
        <ion-infinite-scroll-content
          loading-spinner="bubbles"
          loading-text="Loading…"
        />
      </ion-infinite-scroll>
    </ion-content>
  </ion-page>
</template>
