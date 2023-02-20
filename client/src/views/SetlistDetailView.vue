<script setup>
import { useFetch } from '@/client'
import SetlistAvatar from '../components/SetlistAvatar.vue'
import SongsheetItem from '@/components/SongsheetItem.vue'
import AddToLibraryButton from '../components/AddToLibraryButton.vue'
import ShareItem from '@/components/ShareItem.vue'
import ShareButton from '@/components/ShareButton.vue'
import { toastController, actionSheetController } from '@ionic/vue'
import * as icons from '@/icons'
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { gradient } from '@/lib/gradient'
import { pluralize } from '@/util'

const props = defineProps({
  id: {
    type: String,
    required: true
  }
})

const router = useRouter()
const editing = ref(false)
const songsheets = ref(null) // element ref

async function reorder (e) {
  const songsheet = songsheets.value.items[e.detail.from]

  await useFetch(`setlists/${props.id}/items/${songsheet.id}`).patch({
    item: { position: e.detail.to + 1 }
  })

  e.detail.complete(true)
}

async function remove (songsheet) {
  await useFetch(`setlists/${props.id}/items/${songsheet.id}`).delete()
  const items = songsheets.value.items
  items.splice(items.indexOf(songsheet), 1)

  return (await toastController.create({
    message: `${songsheet.title} was removed from this setlist`,
    duration: 3000
  })).present()
}

async function destroy () {
  const actionSheet = await actionSheetController
    .create({
      header: 'Are you sure you want to delete this setlist?',
      buttons: [
        {
          text: 'Delete setlist',
          role: 'destructive',
          icon: icons.trash,
          handler: async () => {
            await useFetch(`setlists/${props.id}`).delete()
            router.back({ name: 'setlists' })
          }
        },
        { text: 'Cancel', icon: close, role: 'cancel' }
      ]
    })
  await actionSheet.present()
}
</script>

<template>
  <app-view>
    <data-source
      v-slot="{ data }"
      :src="`setlists/${id}`"
    >
      <Head>
        <title v-if="data">
          Setlist: {{ data.title }}
        </title>
      </Head>
      <ion-content fullscreen>
        <ion-refresher
          v-if="$refs.songsheets"
          slot="fixed"
          @ion-refresh="$refs.songsheets.reload"
        >
          <ion-refresher-content />
        </ion-refresher>
        <ion-header
          slot="fixed"
          translucent
          collapse="fade"
        >
          <ion-toolbar>
            <ion-title>{{ data?.title }}</ion-title>

            <ion-buttons slot="start">
              <ion-back-button
                text=""
                :default-href="{ name: 'setlists' }"
              />
            </ion-buttons>

            <ion-buttons
              slot="end"
              class="pr-[16px]"
            >
              <ion-button
                v-show="editing"
                @click="editing = false"
              >
                Done
              </ion-button>
              <ion-button
                v-show="!editing"
                :id="`setlist-context-${id}`"
              >
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

        <ion-header
          collapse="condense"
          :style="`background-image: linear-gradient(rgba(0,0,0,0.2), rgba(0,0,0,0.3) 33%, rgba(0,0,0,0.8)), ${gradient(data?.id)};`"
          class="block bg-slate-700 always-dark toolbar-padding"
        >
          <ion-toolbar
            style="--background: transparent; --padding-top: 2rem;"
            class="p-8"
          >
            <div class="flex flex-col sm:flex-row gap-8 lg:gap-10">
              <div class="min-w-[200px]">
                <setlist-avatar
                  :id="data?.id"
                  :thumbnails="data?.thumbnails"
                  class="shadow-xl"
                />
              </div>
              <div class="text-white text-shadow flex flex-col gap-3">
                <ion-note class="text-white text-xs font-semibold uppercase tracking-wide">
                  Setlist
                </ion-note>
                <h1 class="text-4xl font-bold">
                  {{ data?.title }}
                </h1>
                <div
                  v-if="data?.description"
                  class="opacity-60"
                >
                  {{ data?.description }}
                </div>
                <div class="text-sm">
                  <ion-chip
                    color="light"
                    class="m-0"
                  >
                    <ion-avatar>
                      <img
                        alt="Silhouette of a person's head"
                        src="https://ionicframework.com/docs/img/demos/avatar.svg"
                      >
                    </ion-avatar>
                    <ion-label>{{ data?.user?.name || 'unknown' }}</ion-label>
                  </ion-chip>

                  <span class="inline-block mx-1">•</span>

                  {{ pluralize(data?.songs_count, 'song', 'songs') }}
                </div>

                <ion-buttons class="mt-4">
                  <add-to-library-button
                    :id="id"
                    size="large"
                    color="light"
                  />
                  <share-button
                    :title="data?.title"
                    :router-link="{ name: 'setlist', params: { id } }"
                    color="light"
                  />
                </ion-buttons>

                <ion-popover
                  :trigger="`setlist-context-${id}`"
                  dismiss-on-select
                >
                  <ion-list>
                    <ion-item
                      button
                      detail
                      :detail-icon="icons.edit"
                      @click="editing = true"
                    >
                      <ion-label>Edit</ion-label>
                    </ion-item>
                    <ion-item
                      button
                      detail
                      :detail-icon="icons.trash"
                      @click="destroy"
                    >
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

        <ion-list class="pt-3">
          <ion-reorder-group
            :disabled="!editing"
            @ion-item-reorder="reorder"
          >
            <data-source
              ref="songsheets"
              v-slot="{ items }"
              :src="`setlists/${props.id}/songsheets`"
              paginate
            >
              <ion-item-sliding
                v-for="songsheet in items"
                :key="songsheet.id"
              >
                <ion-item-options side="end">
                  <ion-item-option
                    color="danger"
                    @click="remove(songsheet)"
                  >
                    Remove
                  </ion-item-option>
                </ion-item-options>

                <songsheet-item
                  v-bind="songsheet"
                  :setlist-id="id"
                />
              </ion-item-sliding>
            </data-source>
          </ion-reorder-group>
        </ion-list>
      </ion-content>
    </data-source>
  </app-view>
</template>

<style>
.ios.toolbar-padding { padding-top: 44px; }
.md.toolbar-padding { padding-top: 56px; }
</style>
