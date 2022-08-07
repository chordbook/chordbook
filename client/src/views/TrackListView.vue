<template>
  <app-view>
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
      <data-source
        v-slot="{ items }"
        :src="$route.path"
        :params="$route.query"
        paginate
      >
        <ion-list>
          <track-item
            v-for="track in items"
            :key="track.id"
            :track="track"
          />
        </ion-list>
      </data-source>
    </ion-content>
  </app-view>
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
