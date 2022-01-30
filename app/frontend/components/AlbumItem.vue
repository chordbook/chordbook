<template>
  <ion-item
    button
    :router-link="{ name: 'album', params: { id: album.id } }"
  >
    <ion-avatar slot="start">
      <img
        :src="album.thumbnail"
        class="rounded"
      >
    </ion-avatar>
    <ion-label>
      <h2>{{ album.title }}</h2>
      <p>{{ album.artist.name }}</p>
    </ion-label>
  </ion-item>
</template>

<script>
import { IonItem, IonAvatar, IonLabel } from '@ionic/vue'

export default {
  components: { IonItem, IonAvatar, IonLabel },

  props: {
    album: {
      type: Object,
      required: true
    }
  }
}
</script>
