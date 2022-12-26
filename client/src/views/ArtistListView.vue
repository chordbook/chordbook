<script setup>
import ArtistItem from '@/components/ArtistItem.vue'
import LibraryPlaceholder from '@/components/LibraryPlaceholder.vue'
</script>

<template>
  <app-view>
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
      <data-source
        :src="$route.path"
        :params="$route.query"
        paginate
      >
        <template #empty>
          <library-placeholder type="artist" />
        </template>
        <template #default="{ items }">
          <ion-list>
            <artist-item
              v-for="artist in items"
              :key="artist.id"
              v-bind="artist"
            />
          </ion-list>
        </template>
      </data-source>
    </ion-content>
  </app-view>
</template>
