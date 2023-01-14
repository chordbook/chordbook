<script setup>
import { useFetch } from '@/client'
import SongsheetItem from '@/components/SongsheetItem.vue'
import AddToLibraryButton from '../components/AddToLibraryButton.vue'
import ShareItem from '@/components/ShareItem.vue'
import { toastController, actionSheetController } from '@ionic/vue'
import * as icons from '@/icons'
import { ref } from 'vue'
import { useRouter } from 'vue-router'

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
      <ion-header
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

          <ion-buttons slot="end">
            <ion-button
              v-show="editing"
              @click="editing = false"
            >
              Done
            </ion-button>
            <add-to-library-button
              v-if="!editing"
              :id="id"
            />
            <ion-button
              v-if="!editing"
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

      <ion-content fullscreen>
        <ion-header collapse="condense">
          <ion-toolbar>
            <ion-title>{{ data?.title }}</ion-title>
          </ion-toolbar>
        </ion-header>

        <p class="ion-padding">
          {{ data?.description }}
        </p>

        <ion-list>
          <ion-reorder-group
            :disabled="!editing"
            @ion-item-reorder="reorder"
          >
            <data-source
              ref="songsheets"
              v-slot="{ items }"
              :src="`setlists/${props.id}/songsheets`"
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

                <songsheet-item v-bind="songsheet">
                  <!-- <ion-reorder slot="end"></ion-reorder> -->
                </songsheet-item>
              </ion-item-sliding>
            </data-source>
          </ion-reorder-group>
        </ion-list>
      </ion-content>

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
    </data-source>
  </app-view>
</template>
