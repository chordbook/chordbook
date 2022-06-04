<template>
  <ion-menu>
    <ion-header>
      <ion-toolbar>
        <ion-item
          :router-link="{ name: 'home' }"
          lines="none"
          router-direction="root"
          class="ion-padding-horizontal"
        >
          <img
            slot="start"
            :src="icons.logo"
            style="height: 20px"
          >
          <ion-label>
            <img
              alt="Chord Book"
              :src="icons.wordmark"
              style="height: 14px"
            >
          </ion-label>
        </ion-item>
      </ion-toolbar>
    </ion-header>

    <ion-content class="ion-padding-horizontal">
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
  </ion-menu>
</template>

<script>
import {
  IonMenu,
  IonHeader,
  IonToolbar,
  IonList,
  IonItem,
  IonContent,
  IonIcon,
  IonLabel,
  IonListHeader,
  IonMenuToggle
} from '@ionic/vue'

import * as icons from '@/icons'

export default {
  components: {
    IonMenu,
    IonHeader,
    IonToolbar,
    IonTitle,
    IonList,
    IonItem,
    IonContent,
    IonIcon,
    IonLabel,
    IonListHeader,
    IonMenuToggle
  },

  data () {
    return {
      icons,
      selected: this.$route.meta?.selected || 'discover'
    }
  },

  watch: {
    $route () {
      this.selected = this.$route.meta?.selected || this.selected
    }
  },

  methods: {
    colorFor (item) {
      return item === this.selected ? 'primary' : ''
    }
  }
}
</script>

<style scoped>
ion-menu {
  --primary-color: rgb(33 31 86);
  --ion-text-color: rgb(255 255 255 / 0.9);
}

ion-menu {
  --background:
    linear-gradient(45deg, rgb(34 211 238 / 0.6), transparent 60%),
    linear-gradient(-45deg, rgb(219 39 119 / 0.6), transparent 60%),
    linear-gradient(to bottom, var(--primary-color) 100%, transparent)
    ;
    /*  */
}

ion-list-header {
  --color: #fff;
}

ion-header, ion-content, ion-toolbar, ion-list, ion-item {
  --background: transparent;
  --ion-background-color: transparent;
  --ion-item-background: transparent;
}
.ios ion-item {
  @apply rounded-lg;
}

ion-icon { color: inherit; }
/* .ion-color-primary ion-icon { color: inherit; } */
</style>
