<template>
  <ion-menu>
    <ion-header translucent>
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-menu-button />
        </ion-buttons>
      </ion-toolbar>
    </ion-header>

    <ion-content
      fullscreen
      class="ion-padding-horizontal"
    >
      <div class="flex h-full flex-col">
        <ion-list
          lines="none"
          class="py-4"
        >
          <ion-menu-toggle auto-hide="false">
            <ion-item
              button
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
            <ion-item
              button
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
            <ion-item
              button
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
            <ion-item
              button
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
            <ion-item
              button
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

        <ion-list
          v-if="!auth.isAuthenticated"
          lines="none"
          class="mt-auto mb-3"
        >
          <ion-menu-toggle
            auto-hide="false"
          >
            <ion-button
              class="block"
              color="primary"
              fill="outline"
              router-link="#signin"
            >
              <ion-icon
                slot="start"
                size="small"
                :icon="icons.signin"
              />
              Sign In
            </ion-button>
          </ion-menu-toggle>
        </ion-list>
      </div>
    </ion-content>
    <ion-footer translucent>
      <ion-toolbar>
        <ion-buttons>
          <ion-button
            button
            shape="round"
            router-link="#chords"
            :detail="false"
            :color="colorFor('songs')"
          >
            <ion-icon
              slot="icon-only"
              size="small"
              :icon="icons.chordDiagram"
            />
          </ion-button>
          <ion-button
            button
            shape="round"
            router-link="#tuner"
            :detail="false"
            :color="colorFor('songs')"
          >
            <ion-icon
              slot="icon-only"
              size="small"
              :icon="icons.tuningFork"
            />
          </ion-button>
        </ion-buttons>
      </ion-toolbar>
    </ion-footer>
  </ion-menu>
</template>

<script setup>
import { ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import * as icons from '@/icons'
import useAuthStore from '@/stores/auth'

const auth = useAuthStore()
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

.ios ion-item {
  @apply rounded-lg;
}
</style>
