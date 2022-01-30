<template>
  <ion-item
    button
    :router-link="{ name: 'artist', params: { id: artist.id } }"
  >
    <ion-avatar slot="start">
      <img :src="artist.thumbnail">
    </ion-avatar>
    <ion-label>
      <h2>{{ artist.name }}</h2>
    </ion-label>
  </ion-item>
</template>

<script>
import { IonItem, IonAvatar, IonLabel } from '@ionic/vue'

export default {
  components: { IonItem, IonAvatar, IonLabel },

  props: {
    artist: {
      type: Object,
      required: true
    }
  }
}
</script>
