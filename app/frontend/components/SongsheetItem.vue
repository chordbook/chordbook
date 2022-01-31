<template>
  <ion-item
    button
    :router-link="{ name: 'songsheet', params: { id: songsheet.id } }"
  >
    <ion-avatar slot="start">
      <ion-img
        :src="songsheet.track?.album?.thumbnail"
        class="rounded"
      />
    </ion-avatar>
    <ion-label>
      <h2>{{ songsheet.title }}</h2>
      <p v-if="artist">
        {{ artist }}
      </p>
    </ion-label>
  </ion-item>
</template>

<script>
import { IonItem, IonAvatar, IonLabel, IonImg } from '@ionic/vue'

export default {
  components: { IonItem, IonAvatar, IonLabel, IonImg },

  props: {
    songsheet: {
      type: Object,
      required: true
    }
  },

  computed: {
    artist () {
      return this.songsheet?.artists
        ? new Intl.ListFormat().format(this.songsheet.artists.map(a => a.name))
        : this.songsheet.metadata?.subtitle
    }
  }
}
</script>
