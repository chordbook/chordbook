<template>
  <ion-page>
    <ion-tabs>
      <ion-router-outlet />
      <ion-tab-bar
        slot="bottom"
        translucent
      >
        <ion-tab-button
          tab="home"
          href="/home"
        >
          <ion-icon :icon="home" />
          <ion-label>Home</ion-label>
        </ion-tab-button>

        <ion-tab-button
          tab="discover"
          href="/discover"
        >
          <ion-icon :icon="search" />
          <ion-label>Discover</ion-label>
        </ion-tab-button>

        <ion-tab-button
          tab="library"
          href="/songsheets"
        >
          <ion-icon :icon="library" />
          <ion-label>Library</ion-label>
        </ion-tab-button>
      </ion-tab-bar>
    </ion-tabs>
  </ion-page>
</template>

<script>
import { IonTabBar, IonTabButton, IonTabs, IonLabel, IonIcon, IonPage, IonRouterOutlet } from '@ionic/vue'
import { search, library, home } from 'ionicons/icons'

export default {
  components: { IonLabel, IonTabs, IonTabBar, IonTabButton, IonIcon, IonPage, IonRouterOutlet },
  setup () {
    return {
      search,
      library,
      home
    }
  }
}
</script>
