<template>
  <ion-list>
    <ion-item
      v-for="result in results"
      :key="result.type + result.id"
      button
      :router-link="{ name: result.type.toLowerCase(), params: { id: result.id } }"
    >
      <ion-avatar slot="start">
        <ion-img :src="result.thumbnail" /> <!-- class="rounded" -->
      </ion-avatar>
      <ion-label>
        <p class="uppercase">
          {{ result.type }}
        </p>
        <h2>{{ result.title }}</h2>
        <p>{{ result.subtitle }}</p>
      </ion-label>
    </ion-item>
  </ion-list>
</template>

<script>
import { IonList, IonItem, IonAvatar, IonLabel, IonImg } from '@ionic/vue'

export default {
  components: { IonList, IonItem, IonAvatar, IonLabel, IonImg },

  props: {
    params: {
      type: Object,
      required: true
    }
  },

  data () {
    return {
      results: []
    }
  },

  watch: {
    params: { immediate: true, deep: true, handler: 'update' }
  },

  methods: {
    async update () {
      if (!this.params.q) {
        this.results = []
        return
      }

      this.results = (await this.$http.get('/api/search', { params: this.params })).data
    }
  }
}
</script>
