<template>
  <ion-menu class="dark">
    <ion-header>
      <ion-toolbar>
        <ion-item
          :router-link="{ name: 'home' }"
          lines="none"
          router-direction="root"
          class="ion-padding-horizontal"
          style="--min-height: 0; --background: transparent;"
        >
          <ion-icon
            slot="start"
            size="small"
            class="dark:hidden"
            :icon="icons.logoLight"
          />
          <ion-icon
            slot="start"
            size="small"
            class="hidden dark:inline"
            :icon="icons.logo"
          />
          <img
            alt="Chord Book"
            class="inline dark:hidden"
            :src="icons.wordmarkLight"
            style="height: 12px"
          >
          <img
            alt="Chord Book"
            class="hidden dark:inline"
            :src="icons.wordmark"
            style="height: 12px"
          >
        </ion-item>
      </ion-toolbar>
    </ion-header>

    <ion-content class="ion-padding-horizontal">
      <ion-list
        lines="none"
        class="py-4"
      >
        <ion-menu-toggle auto-hide="false">
          <ion-item
            button
            shape="round"
            :router-link="{ name: 'home' }"
            router-direction="root"
            :detail="false"
            :color="colorFor('home')"
          >
            <ion-icon
              slot="start"
              size="small"
              :icon="icons.home"
            />
            <ion-label>Home</ion-label>
          </ion-item>
        </ion-menu-toggle>
        <ion-menu-toggle auto-hide="false">
          <ion-item
            button
            shape="round"
            :router-link="{ name: 'discover' }"
            router-direction="root"
            :detail="false"
            :color="colorFor('discover')"
          >
            <ion-icon
              slot="start"
              size="small"
              :icon="icons.search"
            />
            <ion-label>Discover</ion-label>
          </ion-item>
        </ion-menu-toggle>
      </ion-list>

      <ion-list lines="none">
        <ion-list-header lines="none">
          Library
        </ion-list-header>
        <ion-menu-toggle auto-hide="false">
          <ion-item
            button
            shape="round"
            router-link="/songsheets"
            router-direction="root"
            :detail="false"
            :color="colorFor('songs')"
          >
            <ion-icon
              slot="start"
              size="small"
              :icon="icons.song"
            />
            Songs
          </ion-item>
        </ion-menu-toggle>
        <ion-menu-toggle auto-hide="false">
          <ion-item
            button
            shape="round"
            router-link="/artists"
            router-direction="root"
            :detail="false"
            :color="colorFor('artists')"
          >
            <ion-icon
              slot="start"
              size="small"
              :icon="icons.artist"
            />
            Artists
          </ion-item>
        </ion-menu-toggle>
        <ion-menu-toggle auto-hide="false">
          <ion-item
            button
            shape="round"
            router-link="/albums"
            router-direction="root"
            :detail="false"
            :color="colorFor('albums')"
          >
            <ion-icon
              slot="start"
              size="small"
              :icon="icons.album"
            />
            Albums
          </ion-item>
        </ion-menu-toggle>
        <ion-menu-toggle auto-hide="false">
          <ion-item
            button
            shape="round"
            router-link="/setlists"
            router-direction="root"
            :detail="false"
            :color="colorFor('setlists')"
          >
            <ion-icon
              slot="start"
              size="small"
              :icon="icons.setlist"
            />
            Setlists
          </ion-item>
        </ion-menu-toggle>
      </ion-list>
    </ion-content>
    <ion-footer>
      <ion-toolbar class="text-center">
        <current-user />
      </ion-toolbar>
    </ion-footer>
  </ion-menu>
</template>

<script setup>
import { ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import * as icons from '@/icons'
import CurrentUser from './CurrentUser.vue'

const route = useRoute()
const selected = ref('discover')

watch(route, () => (selected.value = route.meta?.selected || selected.value), { immediate: true })

function colorFor (item) {
  return item === selected.value ? 'primary' : ''
}
</script>

<style scoped>
ion-menu {
  @apply border-r dark:border-zinc-900;
}

.ios ion-toolbar {
  /* --background: transparent; */
}

.ios ion-item {
  @apply rounded-lg;
}
</style>
