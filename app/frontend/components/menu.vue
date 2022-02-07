<template>
  <ion-menu>
    <ion-header
      translucent
      collapse="fade"
    >
      <ion-toolbar>
        <ion-title>Chord Book</ion-title>
      </ion-toolbar>
    </ion-header>

    <ion-content class="ion-padding-horizontal">
      <ion-header collapse="condense">
        <ion-toolbar>
          <ion-title size="large">
            Chord Book
          </ion-title>
        </ion-toolbar>
      </ion-header>

      <ion-list
        lines="none"
      >
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

      <ion-list
        lines="none"
      >
        <ion-list-header
          lines="none"
        >
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
              :icon="icons.musicalNote"
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
              :icon="icons.peopleCircle"
            />
            Artists
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
  IonTitle,
  IonList,
  IonItem,
  IonContent,
  IonIcon,
  IonLabel,
  IonListHeader,
  IonMenuToggle
} from '@ionic/vue'

import { search, musicalNote, peopleCircle } from 'ionicons/icons'

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
      icons: { search, musicalNote, peopleCircle },
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
ion-menu, ion-header, ion-content {
  --background: var(--ion-color-step-50, #f7f7f7);
}

ion-toolbar, ion-list, ion-item {
  --ion-background-color: transparent;
  --ion-item-background: transparent;
}
.ios ion-item {
  @apply rounded-lg;
}

ion-icon { color: var(--ion-color-primary); }
.ion-color-primary ion-icon { color: inherit; }
</style>
