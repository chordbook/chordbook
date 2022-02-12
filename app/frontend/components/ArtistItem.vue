<template>
  <ion-item
    button
    :router-link="{ name: 'artist', params: { id: artist.id } }"
  >
    <ion-avatar
      slot="start"
      class="bg-slate-100 flex place-content-center items-center"
    >
      <img
        v-if="artist.thumbnail"
        :src="artist.thumbnail"
      >
      <ion-icon
        v-else
        :icon="people"
        class="text-slate-300"
      />
    </ion-avatar>
    <ion-label>
      <h2>{{ artist.name }}</h2>
    </ion-label>
  </ion-item>
</template>

<script>
import { IonItem, IonAvatar, IonLabel, IonIcon } from '@ionic/vue'
import { people } from 'ionicons/icons'

export default {
  components: { IonItem, IonAvatar, IonLabel, IonIcon },

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
