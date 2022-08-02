<script setup>
import ArtistItem from '@/components/ArtistItem.vue'
import LibraryPlaceholder from '@/components/LibraryPlaceholder.vue'
</script>

<template>
  <ion-page>
    <ion-header translucent>
      <ion-toolbar>
        <ion-title>Artists</ion-title>

        <ion-buttons slot="start">
          <ion-back-button
            class="md:hidden"
            text=""
            :default-href="$route.path.replace('/artists', '') || '/library'"
          />
        </ion-buttons>
      </ion-toolbar>
    </ion-header>

    <ion-content>
      <ion-header collapse="condense">
        <ion-toolbar>
          <ion-title size="large">
            Artists
          </ion-title>
        </ion-toolbar>
      </ion-header>

      <ion-list>
        <data-source
          :src="$route.path"
          :params="$route.query"
          paginate
        >
          <template #empty>
            <library-placeholder type="artist" />
          </template>
          <template #default="{ items }">
            <artist-item
              v-for="artist in items"
              :key="artist.id"
              :artist="artist"
            />
          </template>
        </data-source>
      </ion-list>
    </ion-content>
  </ion-page>
</template>
