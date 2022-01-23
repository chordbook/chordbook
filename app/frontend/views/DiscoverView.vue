<template>
  <ion-page>
    <ion-header>
      <ion-toolbar>
        <ion-title>Discover</ion-title>
      </ion-toolbar>
    </ion-header>
    <ion-content fullscreen>
      <ion-header collapse="condense">
        <ion-toolbar>
          <ion-title size="large">
            Discover
          </ion-title>
        </ion-toolbar>
      </ion-header>

      <!-- Default Searchbar -->
      <ion-searchbar
        v-model="q"
        debounce="200"
      />

      <GenreListView />
    </ion-content>
  </ion-page>
</template>

<script lang="ts">
import { IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonSearchbar } from '@ionic/vue'
import { ref } from 'vue'
import GenreListView from '@/views/GenreListView.vue'

export default {
  components: { GenreListView, IonHeader, IonToolbar, IonTitle, IonContent, IonPage, IonSearchbar },

  setup () {
    return { q: ref('') }
  }
}
</script>
