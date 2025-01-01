<script setup lang="ts">
import GenreListView from "@/views/GenreListView.vue";
import ModelAvatar from "@/components/ModelAvatar.vue";
import { useRouteQuery } from "@vueuse/router";
import { ref, reactive } from "vue";
import { getMode } from "@ionic/core";
import { useFetch } from "@/client";
import type { Discover } from "@/api";

const types = {
  All: "",
  Artists: "Artist",
  Albums: "Album",
  Songs: "Songsheet",
  Setlists: "Setlist",
};

const mode = getMode();
const params = reactive({
  q: useRouteQuery("q"),
  type: useRouteQuery("type", ""),
});

const input = ref(); // template ref
const search = ref(); // template ref
</script>

<template>
  <app-view>
    <Head>
      <title>Discover</title>
    </Head>
    <ion-header translucent collapse="fade">
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-menu-button />
        </ion-buttons>
        <ion-title>Discover</ion-title>
      </ion-toolbar>
    </ion-header>
    <ion-content fullscreen class="main-content">
      <ion-header
        :collapse="mode === 'ios' ? 'condense' : ''"
        class="md:flex md:flex-wrap md:gap-2 md:items-center"
      >
        <ion-toolbar class="no-md md:flex-1">
          <ion-title size="large"> Discover </ion-title>
        </ion-toolbar>
        <ion-toolbar class="md:flex-1">
          <ion-searchbar
            ref="input"
            v-model="params.q"
            debounce="200"
            animated
            class="md:pb-0"
            inputmode="search"
          />
        </ion-toolbar>
        <ion-toolbar v-if="params.q">
          <ion-segment
            :value="params.type"
            @ion-change="params.type = $event.detail.value"
          >
            <ion-segment-button
              v-for="(id, name) in types"
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
          v-if="search?.isFetching"
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
        v-if="params.q"
        ref="search"
        src="search"
        :params="params"
        :options="{ immediate: !!params.q, refetch: true }"
      >
        <template v-if="params.q" #empty>
          <blank-slate icon="search" title="No results found" description="" />
        </template>
        <template #default="{ data }">
          <ion-list>
            <TransitionGroup name="fade">
              <ion-item
                v-for="result in data"
                :key="result.type + result.id"
                button
                :router-link="{
                  name: result.type.toLowerCase(),
                  params: { id: result.id },
                }"
                @click="useFetch(result.convert_url)"
              >
                <model-avatar
                  slot="start"
                  :src="result.thumbnail"
                  :type="result.type"
                />
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

      <div v-show="!params.q">
        <data-source v-slot="{ data }: { data: Discover }" src="discover">
          <model-list :items="data?.setlists" format="card" />
        </data-source>
        <GenreListView />
      </div>
    </ion-content>
  </app-view>
</template>

<style scoped>
.md ion-content ion-header {
  box-shadow: none !important;
}

.md .no-md {
  display: none;
}

ion-searchbar {
  padding-bottom: 0 !important;
}

.header-collapse-condense ion-toolbar {
  @apply md:static;
}
</style>
