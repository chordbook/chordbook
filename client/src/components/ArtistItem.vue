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
import { people } from 'ionicons/icons'

export default {
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
