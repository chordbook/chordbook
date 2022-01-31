<template>
  <ion-item
    button
    :router-link="{ name: 'album', params: { id: album.id } }"
    class="rounded"
    :detail="false"
    lines="none"
  >
    <ion-label>
      <div class="rounded aspect-square shadow-md bg-slate-100 dark:bg-slate-900 mb-2 flex place-content-center items-center">
        <ion-img
          v-if="album.thumbnail"
          :src="album.thumbnail"
        />
        <ion-icon
          v-else
          :icon="albums"
          class="text-slate-300 text-5xl"
        />
      </div>
      <h2 class="text-sm">
        {{ album.title }}
      </h2>
      <p>{{ album.artist.name }} • {{ album.released }}</p>
    </ion-label>
  </ion-item>
</template>

<script>
import { IonItem, IonLabel, IonImg, IonIcon } from '@ionic/vue'
import { albums } from 'ionicons/icons'

export default {
  components: { IonItem, IonLabel, IonImg, IonIcon },

  props: {
    album: {
      type: Object,
      required: true
    }
  },

  data () {
    return { albums }
  }
}
</script>
