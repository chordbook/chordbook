<template>
  <ion-page>
    <ion-tabs>
      <ion-router-outlet />
      <ion-tab-bar
        slot="bottom"
        translucent
        class="lg:hidden"
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
          href="/library"
        >
          <ion-icon :icon="library" />
          <ion-label>Library</ion-label>
        </ion-tab-button>
      </ion-tab-bar>
    </ion-tabs>
  </ion-page>
</template>

<script>
import { search, library, home } from 'ionicons/icons'

export default {
  setup () {
    return {
      search,
      library,
      home
    }
  }
}
</script>
