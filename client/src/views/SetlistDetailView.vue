<script setup lang="ts">
import { useFetch } from "@/client";
import ShareButton from "@/components/ShareButton.vue";
import ShareItem from "@/components/ShareItem.vue";
import SongsheetItem from "@/components/SongsheetItem.vue";
import * as icons from "@/icons";
import { gradient } from "@/lib/gradient";
import { pluralize } from "@/util";
import { actionSheetController, toastController, useIonRouter } from "@ionic/vue";
import { ref, useTemplateRef } from "vue";
import AddToLibraryButton from "../components/AddToLibraryButton.vue";
import SetlistAvatar from "../components/SetlistAvatar.vue";

import type { Songsheet } from "@/api";
import type { DataSource } from "@/components";
import type { ItemReorderEventDetail } from "@ionic/core";

const props = defineProps({
  id: {
    type: String,
    required: true,
  },
});

const router = useIonRouter();
const editing = ref(false);
const songsheets = useTemplateRef<InstanceType<typeof DataSource>>("songsheets"); // element ref

async function reorder({ detail }: { detail: ItemReorderEventDetail }) {
  const songsheet = songsheets.value?.items[detail.from];

  await useFetch(`setlists/${props.id}/items/${songsheet.id}`).patch({
    item: { position: detail.to + 1 },
  });

  detail.complete(true);
}

async function remove(songsheet: Songsheet) {
  await useFetch(`setlists/${props.id}/items/${songsheet.id}`).delete();
  const items = songsheets.value!.items;
  items.splice(items.indexOf(songsheet), 1);

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
  <app-view>
    <data-source v-slot="{ data }" :src="`setlists/${id}`">
      <Head>
        <title v-if="data">Setlist: {{ data.title }}</title>
      </Head>
      <ion-header translucent>
        <ion-toolbar>
          <ion-title>{{ data?.title }}</ion-title>

          <ion-buttons slot="start">
            <ion-back-button text="" :default-href="{ name: 'setlists' }" />
          </ion-buttons>

          <ion-buttons slot="end" class="pr-[16px]">
            <ion-button v-show="editing" @click="editing = false"> Done </ion-button>
            <ion-button v-show="!editing" :id="`setlist-context-${id}`">
              <ion-icon
                slot="icon-only"
                size="small"
                :ios="icons.iosEllipsis"
                :md="icons.mdEllipsis"
              />
            </ion-button>
          </ion-buttons>
        </ion-toolbar>
      </ion-header>
      <ion-content fullscreen>
        <ion-refresher
          v-if="$refs.songsheets"
          slot="fixed"
          @ion-refresh="songsheets?.reload().then(() => $event.target.complete())"
        >
          <ion-refresher-content />
        </ion-refresher>

        <ion-header
          collapse="condense"
          :style="`background-image: linear-gradient(rgba(0,0,0,0.2), rgba(0,0,0,0.3) 33%, rgba(0,0,0,0.8)), ${gradient(data?.id)};`"
          class="block bg-slate-700 always-dark main-content"
        >
          <ion-toolbar style="--background: transparent; --padding-top: 1.5rem">
            <div class="flex flex-col sm:flex-row gap-4 sm:gap-6 md:gap-8 lg:gap-10 ion-padding">
              <div class="min-w-[200px]">
                <setlist-avatar :id="data?.id" :thumbnails="data?.thumbnails" class="shadow-xl" />
              </div>
              <div class="text-white text-shadow flex flex-col gap-3">
                <ion-note class="text-white text-xs font-semibold uppercase tracking-wide">
                  Setlist
                </ion-note>
                <h1 class="text-4xl font-bold">
                  {{ data?.title }}
                </h1>
                <div v-if="data?.description" class="opacity-60">
                  {{ data?.description }}
                </div>
                <div class="text-sm">
                  <ion-chip color="light" class="m-0">
                    <ion-avatar>
                      <img
                        alt="Silhouette of a person's head"
                        src="https://ionicframework.com/docs/img/demos/avatar.svg"
                      />
                    </ion-avatar>
                    <ion-label>{{ data?.user?.name || "unknown" }}</ion-label>
                  </ion-chip>

                  <span class="inline-block mx-1">•</span>

                  {{ pluralize(data?.songs_count, "song", "songs") }}
                </div>

                <ion-buttons>
                  <add-to-library-button :id="id" size="large" color="light" />
                  <share-button
                    :title="data?.title"
                    :router-link="{ name: 'setlist', params: { id } }"
                    color="light"
                  />
                </ion-buttons>

                <ion-popover :trigger="`setlist-context-${id}`" dismiss-on-select>
                  <ion-list>
                    <ion-item button detail :detail-icon="icons.edit" @click="editing = true">
                      <ion-label>Edit</ion-label>
                    </ion-item>
                    <ion-item button detail :detail-icon="icons.trash" @click="destroy">
                      <ion-label>Delete</ion-label>
                    </ion-item>
                    <share-item
                      lines="none"
                      :title="data?.title"
                      :router-link="{ name: 'setlist', params: { id } }"
                    />
                  </ion-list>
                </ion-popover>
              </div>
            </div>
          </ion-toolbar>
        </ion-header>

        <div class="main-content">
          <ion-list>
            <ion-reorder-group :disabled="!editing" @ion-item-reorder="reorder">
              <data-source
                ref="songsheets"
                v-slot="{ items }"
                :src="`setlists/${props.id}/songsheets`"
              >
                <ion-item-sliding v-for="songsheet in items" :key="songsheet.id">
                  <ion-item-options side="end">
                    <ion-item-option color="danger" @click="remove(songsheet)">
                      Remove
                    </ion-item-option>
                  </ion-item-options>

                  <songsheet-item v-bind="songsheet" :setlist-id="id">
                    <template #actions>
                      <ion-item
                        button
                        detail
                        :detail-icon="icons.setlist"
                        @click="remove(songsheet)"
                      >
                        <ion-label color="danger">Remove</ion-label>
                      </ion-item>
                    </template>
                  </songsheet-item>
                </ion-item-sliding>
              </data-source>
            </ion-reorder-group>
          </ion-list>
        </div>
      </ion-content>
    </data-source>
  </app-view>
</template>
