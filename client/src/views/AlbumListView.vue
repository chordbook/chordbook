<template>
  <app-view>
    <Head>
      <title>Albums</title>
    </Head>
    <ion-header
      translucent
      collapse="fade"
    >
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button
            class="md:hidden"
            text=""
            :default-href="backLink"
          />
        </ion-buttons>
        <ion-title>Albums</ion-title>
      </ion-toolbar>
    </ion-header>

    <ion-content fullscreen>
      <ion-header collapse="condense">
        <ion-toolbar>
          <ion-title size="large">
            Albums
          </ion-title>
        </ion-toolbar>
      </ion-header>
      <data-source
        :src="$route.path"
        :params="$route.params"
      >
        <template #empty>
          <library-placeholder type="album" />
        </template>
        <template #default="{ items }">
          <ion-list>
            <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 2xl:grid-cols-8">
              <album-item
                v-for="album in items"
                :key="album.id"
                v-bind="album"
              />
            </div>
          </ion-list>
        </template>
      </data-source>
    </ion-content>
  </app-view>
</template>

<script>
import AlbumItem from '@/components/AlbumItem.vue'
import LibraryPlaceholder from '@/components/LibraryPlaceholder.vue'

export default {
  components: { AlbumItem, LibraryPlaceholder },

  computed: {
    backLink () {
      return this.$route.path.replace('/albums', '')
    }
  }
}
</script>
