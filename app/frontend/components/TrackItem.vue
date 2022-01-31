<template>
  <ion-item
    button
    :router-link="{ name: 'track', params: { id: track.id } }"
  >
    <ion-avatar slot="start">
      <ion-img
        :src="track.album?.thumbnail"
        class="rounded"
      />
    </ion-avatar>
    <ion-label>
      <h2>{{ track.title }}</h2>
      <p>{{ track.artist.name }}</p>
    </ion-label>
  </ion-item>
</template>

<script>
import { IonItem, IonAvatar, IonLabel, IonImg } from '@ionic/vue'

export default {
  components: { IonItem, IonAvatar, IonLabel, IonImg },

  props: {
    track: {
      type: Object,
      required: true
    }
  }
}
</script>
