<script setup lang="ts">
import type { Discover, SearchResult } from "@/api";
import ModelAvatar from "@/components/ModelAvatar.vue";
import { useFetch } from "@/composables";
import GenreListView from "@/views/GenreListView.vue";
import { getMode } from "@ionic/core";
import { useRouteQuery } from "@vueuse/router";
import { reactive, ref } from "vue";

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
  <AppView>
    <Head>
      <title>Discover</title>
    </Head>
    <IonHeader translucent collapse="fade">
      <IonToolbar>
        <IonButtons slot="start">
          <IonMenuButton />
        </IonButtons>
        <IonTitle>Discover</IonTitle>
      </IonToolbar>
    </IonHeader>
    <IonContent fullscreen class="main-content">
      <IonHeader
        :collapse="mode === 'ios' ? 'condense' : ''"
        class="md:flex md:flex-wrap md:gap-2 md:items-center"
      >
        <IonToolbar class="no-md md:flex-1">
          <IonTitle size="large"> Discover </IonTitle>
        </IonToolbar>
        <IonToolbar class="md:flex-1">
          <IonSearchbar
            ref="input"
            v-model="params.q"
            debounce="200"
            animated
            class="md:pb-0"
            inputmode="search"
          />
        </IonToolbar>
        <IonToolbar v-if="params.q">
          <IonSegment :value="params.type" @ion-change="params.type = $event.detail.value">
            <IonSegmentButton v-for="(id, name) in types" :key="id" :value="id">
              <IonLabel>{{ name }}</IonLabel>
            </IonSegmentButton>
          </IonSegment>
        </IonToolbar>
      </IonHeader>

      <Transition name="fade">
        <div
          v-if="search?.isFetching"
          slot="fixed"
          class="top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2"
        >
          <IonSpinner name="dots" color="medium" class="scale-[2]" duration="1200" />
        </div>
      </Transition>

      <DataSource
        v-if="params.q"
        ref="search"
        src="search"
        :params="params"
        :options="{ immediate: !!params.q, refetch: true }"
      >
        <template v-if="params.q" #empty>
          <BlankSlate icon="search" title="No results found" description="" />
        </template>
        <template #default="{ data }: { data: SearchResult[] }">
          <IonList>
            <TransitionGroup name="fade">
              <IonItem
                v-for="result in data"
                :key="result.type + result.id"
                button
                :router-link="{
                  name: result.type.toLowerCase(),
                  params: { id: result.id },
                }"
                @click="useFetch(result.convert_url)"
              >
                <ModelAvatar slot="start" :src="result.thumbnail" :type="result.type" />
                <IonLabel>
                  <p class="uppercase">
                    {{ result.type }}
                  </p>
                  <h2>{{ result.title }}</h2>
                  <p>{{ result.subtitle }}</p>
                </IonLabel>
              </IonItem>
            </TransitionGroup>
          </IonList>
        </template>
      </DataSource>

      <div v-show="!params.q">
        <DataSource v-slot="{ data }: { data: Discover }" src="discover">
          <ModelList :items="data?.setlists" format="card" />
        </DataSource>
        <GenreListView />
      </div>
    </IonContent>
  </AppView>
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
