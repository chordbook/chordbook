<template>
  <ion-page>
    <ion-header
      translucent
      collapse="fade"
    >
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button
            text=""
            :default-href="backLink"
          />
        </ion-buttons>
        <ion-title>Songs</ion-title>
      </ion-toolbar>
    </ion-header>

    <ion-content>
      <ion-list>
        <data-source :src="$route.path" :params="$route.query" paginate v-slot="{ data }">
          <track-item
            v-for="track in data"
            :key="track.id"
            :track="track"
          />
        </data-source>
      </ion-list>
    </ion-content>
  </ion-page>
</template>

<script>
import TrackItem from '@/components/TrackItem.vue'

export default {
  components: { TrackItem },

  computed: {
    backLink () {
      return this.$route.path.replace('/tracks', '')
    }
  }
}
</script>
