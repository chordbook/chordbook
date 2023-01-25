<script setup>
import GenreListView from '@/views/GenreListView.vue'
import ModelList from '../components/ModelList.vue'
import { useRouteQuery } from '@vueuse/router'
import { computed, ref, reactive } from 'vue'
import { artist, album, song } from '@/icons'

const types = {
  All: '',
  Artists: 'Artist',
  Albums: 'Album',
  Songs: 'Track,Songsheet'
}

const icons = {
  Artist: artist,
  Album: album,
  Track: song,
  Songsheet: song
}

const params = reactive({
  q: useRouteQuery('q'),
  type: useRouteQuery('type', '')
})

const search = ref(null) // template ref
const hasFocus = ref(false)
const isSearching = computed(() => !!params.q || hasFocus.value)
</script>

<template>
  <app-view>
    <ion-header
      collapse="fade"
      class="ion-no-border"
    >
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-menu-button />
        </ion-buttons>
        <ion-title>Discover</ion-title>
      </ion-toolbar>
    </ion-header>
    <ion-content fullscreen>
      <ion-header
        v-show="!isSearching"
        collapse="condense"
      >
        <ion-toolbar>
          <ion-title size="large">
            Discover
          </ion-title>
        </ion-toolbar>
      </ion-header>

      <ion-header
        collapse="fade"
        class="sticky top-0"
      >
        <ion-toolbar>
          <ion-searchbar
            ref="input"
            v-model="params.q"
            :show-cancel-button="isSearching ? 'always' : 'focus'"
            debounce="200"
            animated
            @ion-focus="hasFocus = true"
            @ion-blur="hasFocus = false"
          />
        </ion-toolbar>
        <ion-toolbar v-show="isSearching">
          <ion-segment
            :value="params.type"
            @ion-change="params.type = $event.detail.value"
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

      <Transition name="fade">
        <div
          v-if="isSearching && search?.isFetching"
          slot="fixed"
          class="top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2"
        >
          <ion-spinner
            name="dots"
            color="medium"
            class="scale-[2]"
            duration="1200"
          />
        </div>
      </Transition>

      <data-source
        v-if="isSearching"
        ref="search"
        src="search"
        :params="params"
        :options="{ immediate: !!params.q, refetch: true }"
        :paginate="false"
      >
        <template
          v-if="params.q"
          #empty
        >
          <blank-slate
            icon="search"
            title="No results found"
            description=""
          />
        </template>
        <template #default="{ data }">
          <ion-list>
            <TransitionGroup name="fade">
              <ion-item
                v-for="result in data"
                :key="result.type + result.id"
                button
                :router-link="{ name: result.type.toLowerCase(), params: { id: result.id } }"
              >
                <ion-avatar
                  slot="start"
                  class="bg-slate-100 flex place-content-center items-center rounded"
                >
                  <img
                    v-if="result.thumbnail"
                    :src="result.thumbnail"
                    :class="{ roundedFull: result.type === 'Artist' }"
                  >
                  <ion-icon
                    v-else
                    :icon="icons[result.type]"
                    class="text-slate-300"
                  />
                </ion-avatar>
                <ion-label>
                  <p class="uppercase">
                    {{ result.type }}
                  </p>
                  <h2>{{ result.title }}</h2>
                  <p>{{ result.subtitle }}</p>
                </ion-label>
              </ion-item>
            </TransitionGroup>
          </ion-list>
        </template>
      </data-source>

      <div v-show="!isSearching">
        <data-source
          v-slot="{ data }"
          src="discover"
        >
          <model-list
            :items="data?.setlists"
            format="card"
          />
        </data-source>
        <GenreListView />
      </div>
    </ion-content>
  </app-view>
</template>
