<script setup>
import * as icons from "@/icons";
</script>

<template>
  <app-view>
    <Head>
      <title>Library</title>
    </Head>
    <ion-header translucent>
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-menu-button />
        </ion-buttons>
        <ion-title>Library</ion-title>
        <ion-buttons slot="end">
          <ion-button router-link="/account">
            <ion-icon slot="icon-only" :icon="icons.avatar" />
          </ion-button>
        </ion-buttons>
      </ion-toolbar>
    </ion-header>

    <ion-content fullscreen class="main-content">
      <ion-header collapse="condense">
        <ion-toolbar>
          <ion-title size="large"> Library </ion-title>
        </ion-toolbar>
      </ion-header>

      <ion-list>
        <ion-item button router-link="/songsheets">
          <ion-icon slot="start" size="small" :icon="icons.song" />
          <ion-label>Songs</ion-label>
        </ion-item>
        <ion-item button router-link="/artists">
          <ion-icon slot="start" size="small" :icon="icons.artist" />
          <ion-label>Artists</ion-label>
        </ion-item>
        <ion-item button router-link="/setlists">
          <ion-icon slot="start" size="small" :icon="icons.setlist" />
          <ion-label>Setlists</ion-label>
        </ion-item>
      </ion-list>
    </ion-content>
  </app-view>
</template>
