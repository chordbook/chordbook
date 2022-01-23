<template>
  <ion-item :router-link="{ name: 'track', params: { id: track.id } }">
    <ion-avatar slot="start">
      <img
        :src="track.album?.thumbnail"
        class="rounded"
      >
    </ion-avatar>
    <ion-label>
      <h2>{{ track.title }}</h2>
      <p>{{ track.artist.name }}</p>
    </ion-label>
  </ion-item>
</template>

<script>
import { IonItem, IonAvatar, IonLabel } from '@ionic/vue'

export default {
  components: { IonItem, IonAvatar, IonLabel },

  props: {
    track: {
      type: Object,
      required: true
    }
  }
}
</script>
