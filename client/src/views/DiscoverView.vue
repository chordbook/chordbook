<template>
  <ion-page>
    <ion-header
      collapse="fade"
      class="ion-no-border"
    >
      <ion-toolbar>
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
            debounce="150"
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

      <div>
        <ion-list>
          <div
            class="grid-scroll-x auto-cols-1/2 sm:auto-cols-1/3 md:auto-cols-1/4 lg:auto-cols-1/5 xl:auto-cols-1/6 2xl:auto-cols-1/8"
          >
            <setlist-card
              v-for="setlist in discover?.data?.setlists"
              :key="setlist.id"
              :setlist="setlist"
            />
          </div>
        </ion-list>
      </div>

      <ion-list v-show="isSearching">
        <Transition>
          <ion-item
            v-if="search.isFinished && (!search.data || search.data.length == 0)"
            lines="none"
          >
            No results
          </ion-item>
        </Transition>
        <ion-item
          v-for="result in search.data"
          :key="result.type + result.id"
          button
          :router-link="{ name: result.type.toLowerCase(), params: { id: result.id } }"
        >
          <ion-avatar slot="start">
            <img :src="result.thumbnail"> <!-- class="rounded" -->
          </ion-avatar>
          <ion-label>
            <p class="uppercase">
              {{ result.type }}
            </p>
            <h2>{{ result.title }}</h2>
            <p>{{ result.subtitle }}</p>
          </ion-label>
        </ion-item>
        <Transition name="slide-down">
          <ion-item
            v-if="search.isFetching"
            lines="none"
          >
            <ion-spinner name="dots" />
          </ion-item>
        </Transition>
      </ion-list>
      <GenreListView v-show="!isSearching" />
    </ion-content>
  </ion-page>
</template>

<script setup>
import GenreListView from '@/views/GenreListView.vue'
import SetlistCard from '../components/SetlistCard.vue'
import { useRouteQuery } from '@vueuse/router'
import { useFetch } from '@/client'
import { computed, ref, unref, reactive, watch } from 'vue'

const types = {
  All: '',
  Artists: 'Artist',
  Albums: 'Album',
  Songs: 'Track,Songsheet'
}

const params = reactive({
  q: useRouteQuery('q'),
  type: useRouteQuery('type', '')
})

const hasFocus = ref(false)
const isSearching = computed(() => !!unref(params.q || hasFocus))
const search = reactive(useFetch('search', { params, immediate: params.q }).get().json())
const discover = reactive(useFetch('discover').get().json())

watch(params, () => {
  if (params.q) {
    search.abort()
    search.execute()
  }
})
</script>
