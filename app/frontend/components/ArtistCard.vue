<template>
  <ion-item
    button
    :router-link="{ name: 'artist', params: { id: artist.id } }"
    class="rounded group"
    :detail="false"
    lines="none"
  >
    <ion-label>
      <div>
        <ion-avatar
          class="w-full h-full flex place-content-center items-center overflow-hidden relative aspect-square shadow-md bg-slate-100 dark:bg-slate-900 mb-3"
        >
          <ion-img
            v-if="artist.thumbnail"
            :src="artist.thumbnail"
          />
          <ion-icon
            v-else
            :icon="people"
            class="text-slate-300"
          />
        </ion-avatar>
      </div>
      <h3 class="text-center">{{ artist.name }}</h3>
    </ion-label>
  </ion-item>
</template>

<script>
import { IonItem, IonAvatar, IonLabel, IonIcon, IonImg } from '@ionic/vue'
import { people } from 'ionicons/icons'

export default {
  components: { IonItem, IonAvatar, IonLabel, IonIcon, IonImg },

  props: {
    artist: {
      type: Object,
      required: true
    }
  },

  data () {
    return { people }
  }
}
</script>
