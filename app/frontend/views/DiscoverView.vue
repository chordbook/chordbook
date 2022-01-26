<template>
  <ion-page>
    <ion-header translucent>
      <ion-toolbar>
        <ion-title>Discover</ion-title>
      </ion-toolbar>
    </ion-header>
    <ion-content fullscreen>
      <ion-header collapse="condense">
        <ion-toolbar>
          <ion-title size="large">
            Discover
          </ion-title>
        </ion-toolbar>
        <ion-toolbar>
          <ion-searchbar
            ref="input"
            v-model="searchParams.q"
            :show-cancel-button="isSearching ? 'always' : 'focus'"
            debounce="250"
            animated
          />
        </ion-toolbar>
        <ion-toolbar v-show="isSearching">
          <ion-segment
            :value="searchParams.type || ''"
            @ion-change="searchParams.type = $event.detail.value"
          >
            <ion-segment-button
              v-for="id, name in types"
              :key="id"
              :value="id"
            >
              <ion-label>{{ name }}</ion-label>
            </ion-segment-button>
          </ion-segment>
        </ion-toolbar>
      </ion-header>

      <search-results
        v-show="isSearching"
        :params="searchParams"
      />
      <GenreListView v-show="!isSearching" />
    </ion-content>
  </ion-page>
</template>

<script lang="ts">
import { IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonSearchbar, IonSegment, IonSegmentButton, IonLabel } from '@ionic/vue'
import SearchResults from '@/components/SearchResults.vue'
import GenreListView from '@/views/GenreListView.vue'

export default {
  components: { SearchResults, GenreListView, IonHeader, IonToolbar, IonTitle, IonContent, IonPage, IonSearchbar, IonSegment, IonSegmentButton, IonLabel },

  data () {
    return {
      searchParams: {},
      types: {
        All: '',
        Artists: 'artist',
        Albums: 'album',
        Songs: 'track,songsheet'
      }
    }
  },

  computed: {
    isSearching () {
      return !!this.searchParams.q
    }
  },

  watch: {
    $route: { immediate: true, handler: 'updateFromRoute' },
    searchParams: { deep: true, handler: 'updateRoute' }
  },

  mounted () {
    this.focus()
  },

  methods: {
    updateFromRoute () {
      this.searchParams = this.$route.query
    },

    clear () {
      this.searchParams = {}
    },

    updateRoute () {
      this.$router.push({
        query: Object.assign({}, this.$route.query, this.searchParams),
        replace: true
      })
    },

    focus () {
      this.$refs.input.$el.setFocus()
    }
  }
}
</script>
