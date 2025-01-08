<script setup lang="ts">
import PaginatedList from "@/components/PaginatedList.vue";
import ShareButton from "@/components/ShareButton.vue";
import ShareItem from "@/components/ShareItem.vue";
import SongsheetItem from "@/components/SongsheetItem.vue";
import { useFetch, usePaginatedFetch } from "@/composables";
import * as icons from "@/icons";
import { gradient } from "@/lib/gradient";
import { pluralize } from "@/util";
import { actionSheetController, toastController, useIonRouter } from "@ionic/vue";
import { reactive, ref } from "vue";
import AddToLibraryButton from "../components/AddToLibraryButton.vue";
import SetlistAvatar from "../components/SetlistAvatar.vue";

import type { Songsheet } from "@/api";
import type { ItemReorderCustomEvent } from "@ionic/core";

const props = defineProps({
  id: {
    type: String,
    required: true,
  },
});

const router = useIonRouter();
const editing = ref(false);
const removed = reactive<Songsheet[]>([]);

const dataSource = reactive(usePaginatedFetch<Songsheet[]>(`setlists/${props.id}/songsheets`));
dataSource.load();

async function reorder({ detail }: ItemReorderCustomEvent) {
  const songsheet = dataSource.items[detail.from];

  await useFetch(`setlists/${props.id}/items/${songsheet.id}`).patch({
    item: { position: detail.to + 1 },
  });

  detail.complete(true);
}

async function remove(songsheet: Songsheet) {
  await useFetch(`setlists/${props.id}/items/${songsheet.id}`).delete();
  removed.push(songsheet);

  return (
    await toastController.create({
      message: `${songsheet.title} was removed from this setlist`,
      duration: 3000,
    })
  ).present();
}

async function destroy() {
  const actionSheet = await actionSheetController.create({
    header: "Are you sure you want to delete this setlist?",
    buttons: [
      {
        text: "Delete setlist",
        role: "destructive",
        icon: icons.trash,
        handler: async () => {
          await useFetch(`setlists/${props.id}`).delete();
          router.navigate({ name: "setlists" }, "back");
        },
      },
      { text: "Cancel", icon: icons.close, role: "cancel" },
    ],
  });
  await actionSheet.present();
}
</script>

<template>
  <AppView>
    <DataSource v-slot="{ data }" :src="`setlists/${id}`">
      <Head>
        <title v-if="data">Setlist: {{ data.title }}</title>
      </Head>
      <IonHeader translucent>
        <IonToolbar>
          <IonTitle>{{ data?.title }}</IonTitle>

          <IonButtons slot="start">
            <IonBackButton text="" :default-href="{ name: 'setlists' }" />
          </IonButtons>

          <IonButtons slot="end" class="pr-[16px]">
            <IonButton v-show="editing" @click="editing = false"> Done </IonButton>
            <IonButton v-show="!editing" :id="`setlist-context-${id}`">
              <IonIcon
                slot="icon-only"
                size="small"
                :ios="icons.iosEllipsis"
                :md="icons.mdEllipsis"
              />
            </IonButton>
          </IonButtons>
        </IonToolbar>
      </IonHeader>
      <IonContent fullscreen>
        <IonHeader
          collapse="condense"
          :style="`background-image: linear-gradient(rgba(0,0,0,0.2), rgba(0,0,0,0.3) 33%, rgba(0,0,0,0.8)), ${gradient(data?.id)};`"
          class="block bg-slate-700 always-dark main-content"
        >
          <IonToolbar style="--background: transparent; --padding-top: 1.5rem">
            <div class="flex flex-col sm:flex-row gap-4 sm:gap-6 md:gap-8 lg:gap-10 ion-padding">
              <div class="min-w-[200px]">
                <SetlistAvatar :id="data?.id" :thumbnails="data?.thumbnails" class="shadow-xl" />
              </div>
              <div class="text-white text-shadow flex flex-col gap-3">
                <IonNote class="text-white text-xs font-semibold uppercase tracking-wide">
                  Setlist
                </IonNote>
                <h1 class="text-4xl font-bold">
                  {{ data?.title }}
                </h1>
                <div v-if="data?.description" class="opacity-60">
                  {{ data?.description }}
                </div>
                <div class="text-sm">
                  <IonChip color="light" class="m-0">
                    <IonAvatar>
                      <img
                        alt="Silhouette of a person's head"
                        src="https://ionicframework.com/docs/img/demos/avatar.svg"
                      />
                    </IonAvatar>
                    <IonLabel>{{ data?.user?.name || "unknown" }}</IonLabel>
                  </IonChip>

                  <span class="inline-block mx-1">•</span>

                  {{ pluralize(data?.songs_count, "song", "songs") }}
                </div>

                <IonButtons>
                  <AddToLibraryButton :id="id" size="large" color="light" />
                  <ShareButton
                    :title="data?.title"
                    :router-link="{ name: 'setlist', params: { id } }"
                    color="light"
                  />
                </IonButtons>

                <IonPopover :trigger="`setlist-context-${id}`" dismiss-on-select>
                  <IonList>
                    <IonItem button detail :detail-icon="icons.edit" @click="editing = true">
                      <IonLabel>Edit</IonLabel>
                    </IonItem>
                    <IonItem button detail :detail-icon="icons.trash" @click="destroy">
                      <IonLabel>Delete</IonLabel>
                    </IonItem>
                    <ShareItem
                      lines="none"
                      :title="data?.title"
                      :router-link="{ name: 'setlist', params: { id } }"
                    />
                  </IonList>
                </IonPopover>
              </div>
            </div>
          </IonToolbar>
        </IonHeader>

        <div class="main-content">
          <IonList>
            <IonReorderGroup :disabled="!editing" @ion-item-reorder="reorder">
              <PaginatedList
                :paginate="dataSource.isPaginating"
                @load="$event.waitUntil(dataSource.load())"
                @reload="$event.waitUntil(dataSource.reload())"
              >
                <template v-for="{ data: songsheets } in dataSource.pages">
                  <IonItemSliding v-for="songsheet in songsheets" :key="songsheet.id">
                    <template v-if="!removed.includes(songsheet)">
                      <IonItemOptions side="end">
                        <IonItemOption color="danger" @click="remove(songsheet)">
                          Remove
                        </IonItemOption>
                      </IonItemOptions>

                      <SongsheetItem v-bind="songsheet" :setlist-id="id">
                        <template #actions>
                          <IonItem
                            button
                            detail
                            :detail-icon="icons.setlist"
                            @click="remove(songsheet)"
                          >
                            <IonLabel color="danger">Remove</IonLabel>
                          </IonItem>
                        </template>
                      </SongsheetItem>
                    </template>
                  </IonItemSliding>
                </template>
              </PaginatedList>
            </IonReorderGroup>
          </IonList>
        </div>
      </IonContent>
    </DataSource>
  </AppView>
</template>
