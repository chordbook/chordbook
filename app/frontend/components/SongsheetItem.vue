<template>
  <ion-item
    button
    :router-link="{ name: 'songsheet', params: { id: songsheet.id } }"
  >
    <ion-avatar
      slot="start"
      class="bg-slate-100 flex place-content-center items-center rounded"
    >
      <ion-img
        v-if="songsheet.track?.album"
        :src="songsheet.track?.album?.thumbnail"
        class="rounded"
      />
      <ion-icon
        v-else
        :icon="musicalNote"
        class="text-slate-300"
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
import { IonItem, IonAvatar, IonLabel, IonImg, IonIcon } from '@ionic/vue'
import { musicalNote } from 'ionicons/icons'

export default {
  components: { IonItem, IonAvatar, IonLabel, IonImg, IonIcon },

  props: {
    songsheet: {
      type: Object,
      required: true
    }
  },

  data () {
    return { musicalNote }
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
