<template>
  <ion-item
    button
    :router-link="{ name: 'album', params: { id: album.id } }"
    class="rounded"
    :detail="false"
    lines="none"
  >
    <ion-label>
      <div class="rounded aspect-square shadow-md bg-slate-100 dark:bg-slate-900 mb-2">
        <ion-img :src="album.thumbnail" />
      </div>
      <h2 class="text-sm">
        {{ album.title }}
      </h2>
      <p>{{ album.artist.name }}</p>
    </ion-label>
  </ion-item>
</template>

<script>
import { IonItem, IonLabel, IonImg } from '@ionic/vue'

export default {
  components: { IonItem, IonLabel, IonImg },

  props: {
    album: {
      type: Object,
      required: true
    }
  }
}
</script>
