<template>
  <ion-menu
    class="dark mod maxw-minw width-state"
  >
    <ion-header class="flex-basic">
      <ion-toolbar>
        <ion-item
          :router-link="{ name: 'home' }"
          lines="none"
          router-direction="root"
          class="ion-padding-horizontal ion-item-custom"
        >
          <img
            slot="start"
            class="inline dark:hidden logo"
            :src="icons.logoLight"
            style="height: 20px"
            image="logo"
          >
          <img
            slot="start"
            class="hidden dark:inline logo"
            :src="icons.logo"
            style="height: 20px"
            image="logo"
          >
          <ion-label
            class="wordmark-label"
          >
            <img
              alt="Chord Book"
              class="inline dark:hidden"
              :src="icons.wordmarkLight"
              style="height: 14px"
            >
            <img
              alt="Chord Book"
              class="hidden dark:inline"
              :src="icons.wordmark"
              style="height: 14px"
            >
          </ion-label>
          <ion-button
            class="hamburger-button"
            size="small"
            shape="round"
            fill="clear"
            @click="truncate"
          >
            <img
              alt=""
              class="inline dark:hidden hamburger-icon"
              src="../assets/hamburger-light.svg"
            >
            <img
              alt=""
              class="hidden dark:inline hamburger-icon"
              :src="icons.hamburger"
            >
          </ion-button>
        </ion-item>
      </ion-toolbar>
    </ion-header>

    <ion-content class="ion-padding-horizontal width-only">
      <ion-list lines="none">
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
              v-if="untruncated"
              slot="start"
              size="small"
              :icon="icons.home"
            />
            <ion-icon
              v-else
              :icon="icons.home"
              size="small"
              class="truncated-icon"
            />
            <ion-label v-if="untruncated">
              Home
            </ion-label>
            <ion-label v-else />
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
              v-if="untruncated"
              slot="start"
              size="small"
              :icon="icons.search"
            />
            <ion-icon
              v-else
              :icon="icons.search"
              size="small"
              class="truncated-icon"
            />
            <ion-label v-if="untruncated">
              Discover
            </ion-label>
            <ion-label v-else />
          </ion-item>
        </ion-menu-toggle>
      </ion-list>

      <ion-list lines="none">
        <ion-list-header
          v-if="untruncated"
          style="fontSize: 14px"
          lines="none"
        >
          Library
        </ion-list-header>
        <ion-list-header
          v-else
          style="fontSize: 10px"
          lines="none"
          class="truncated-text"
        >
          Library
        </ion-list-header>
        <ion-menu-toggle auto-hide="false">
          <ion-item
            v-if="untruncated"
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
          <ion-item
            v-else
            button
            shape="round"
            router-link="/songsheets"
            router-direction="root"
            :detail="false"
            :color="colorFor('songs')"
          >
            <ion-icon
              :icon="icons.song"
              size="small"
              class="truncated-icon"
            />
          </ion-item>
        </ion-menu-toggle>
        <ion-menu-toggle auto-hide="false">
          <ion-item
            v-if="untruncated"
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
          <ion-item
            v-else
            button
            shape="round"
            router-link="/artists"
            router-direction="root"
            :detail="false"
            :color="colorFor('artists')"
          >
            <ion-icon
              :icon="icons.artist"
              size="small"
              class="truncated-icon"
            />
          </ion-item>
        </ion-menu-toggle>
        <ion-menu-toggle auto-hide="false">
          <ion-item
            v-if="untruncated"
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
          <ion-item
            v-else
            button
            shape="round"
            router-link="/albums"
            router-direction="root"
            :detail="false"
            :color="colorFor('albums')"
          >
            <ion-icon
              :icon="icons.album"
              size="small"
              class="truncated-icon"
            />
          </ion-item>
        </ion-menu-toggle>
        <ion-menu-toggle auto-hide="false">
          <ion-item
            v-if="untruncated"
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
          <ion-item
            v-else
            button
            shape="round"
            router-link="/setlists"
            router-direction="root"
            :detail="false"
            :color="colorFor('setlists')"
          >
            <ion-icon
              :icon="icons.setlist"
              size="small"
              class="truncated-icon"
            />
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

<script>
export default {
  data () {
    return {
      untruncated: true,
      menuWidth: '330px',
      hamburgerIconHeight: '14px',
      rMargin: '32px',
      wordmarkOpacity: '1'
    }
  },
  methods: {
    truncate (e) {
      e.preventDefault()
      if (this.untruncated) {
        this.untruncated = false
        this.menuWidth = '100px'
        this.rMargin = '10px'
        this.wordmarkOpacity = '0'
      } else {
        this.untruncated = true
        this.menuWidth = '330px'
        this.hamburgerIconHeight = '16px'
        this.rMargin = '32px'
        this.wordmarkOpacity = '1'
      }
    }
  }
}
</script>
<style scoped>
* {
  transition: 0.4s ease-in-out;
}

.logo {
  margin-right: v-bind('rMargin');
}

ion-menu {
  @apply border-r dark:border-zinc-900;
}

.ios ion-item {
  @apply rounded-lg;
}

.ion-item-custom::part(native){
  --padding-end: 5px;
}

.flex-basic {
  display: flex;
}

.maxw-minw {
  max-width: 500px;
  min-width: 130px;
}
.item-inner {
  padding-right: 0px;
}
.width-state {
  max-width: v-bind('menuWidth');
}

.wordmark-label {
  opacity: v-bind(wordmarkOpacity);
}

.hamburger-button {
  --background: none;
  --padding-end: 5px;
  --padding-start: 5px;
  width: fit-content;
  margin-right: 0px;
  margin-left: auto;
}

.hamburger-icon {
  height: v-bind('hamburgerIconHeight');
}

.truncated-icon, .truncated-text {
  margin-left: 20px;
}
</style>
