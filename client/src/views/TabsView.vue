<script setup>
import { search, library, home } from '@/icons'
</script>

<template>
  <ion-page>
    <ion-tabs>
      <ion-router-outlet />
      <ion-tab-bar
        slot="bottom"
        translucent
        class="sm:hidden"
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
