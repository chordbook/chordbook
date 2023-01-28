<script setup>
import SongSheet from '@/components/SongSheet.vue'
import SongsheetEditor from '@/components/SongsheetEditor.vue'
import ChordSheetJS from 'chordsheetjs'
import detectFormat from '@/lib/detect_format'
import { useFetch } from '@/client'
import { alertController, loadingController, modalController } from '@ionic/vue'
import { useRouter } from 'vue-router'
import { ref, computed } from 'vue'

const props = defineProps({
  id: {
    type: String,
    default: null
  }
})

const router = useRouter()
const songsheet = ref({ source: '' })
const errors = ref({})
const parsed = ref(null)
const url = computed(() => props.id ? `songsheets/${props.id}.json` : 'songsheets.json')

if (props.id) {
  useFetch(`songsheets/${props.id}`).get().json().then(({ data }) => {
    songsheet.value = data.value
  })
}

async function save () {
  const { metadata } = parsed.value.metadata
  const method = props.id ? 'patch' : 'post'
  const payload = {
    songsheet: {
      source: songsheet.value.source,
      metadata
    }
  }

  const { error, data } = await useFetch(url).json()[method](payload)

  if (error.value) {
    console.error(error.value)
    errors.value = data.value
  } else {
    router.replace({ name: 'songsheet', params: { id: data.value.id } })
  }
  modalController.dismiss()
}

async function destroy (e) {
  const alert = await alertController
    .create({
      header: 'Are you sure?',
      message: 'Do you want to delete this song?',
      buttons: [
        {
          text: 'Cancel',
          role: 'cancel'
        },
        {
          text: 'Delete',
          role: 'destructive',
          handler: async () => {
            const loading = await loadingController.create({
              message: 'Deleting…',
              duration: 5000,
              translucent: true
            })
            await loading.present()
            await useFetch(url).delete()
            router.go(-2)
            loading.dismiss()
          }
        }
      ]
    })
  return alert.present()
}

function paste (e) {
  const format = detectFormat(e.text)

  // No need to convert if it's already in chordpro
  if (!format || format instanceof ChordSheetJS.ChordProParser) return

  // Convert to ChordPro
  // Modifying text property will change text pasted into Ace editor
  e.text = new ChordSheetJS.ChordProFormatter().format(format.parse(e.text))
}
</script>

<template>
  <app-view>
    <Head>
      <title v-if="id">
        Edit: {{ songsheet.title }}
      </title>
      <title v-else>
        New Song
      </title>
    </Head>
    <ion-header translucent>
      <ion-toolbar>
        <ion-buttons slot="secondary">
          <ion-back-button
            text="Cancel"
            :default-href="id ? `/songsheets/${id}` : '/songsheets'"
          />
        </ion-buttons>

        <ion-buttons slot="primary">
          <ion-button id="trigger-preview">
            <ion-label>Preview</ion-label>
          </ion-button>
        </ion-buttons>
      </ion-toolbar>
    </ion-header>
    <ion-content fullscreen>
      <div v-if="Object.keys(errors).length">
        <ul class="px-8 py-4 text-red-600">
          <li
            v-for="(messages, attr) in errors"
            :key="attr"
          >
            {{ attr }} {{ messages.join(', ') }}
          </li>
        </ul>
      </div>

      <songsheet-editor
        v-model:value="songsheet.source"
        @paste="paste"
      />
    </ion-content>
    <ion-footer>
      <ion-toolbar>
        <ion-buttons slot="secondary">
          <ion-button
            v-if="id"
            fill="clear"
            color="danger"
            @click="destroy"
          >
            Delete
          </ion-button>
        </ion-buttons>
      </ion-toolbar>
    </ion-footer>

    <ion-modal
      ref="preview"
      trigger="trigger-preview"
    >
      <ion-header translucent>
        <ion-toolbar>
          <ion-title>Preview</ion-title>

          <ion-buttons slot="secondary">
            <ion-button @click="modalController.dismiss()">
              <ion-label>Edit</ion-label>
            </ion-button>
          </ion-buttons>

          <ion-buttons slot="primary">
            <ion-button @click="save">
              <ion-label>Save</ion-label>
            </ion-button>
          </ion-buttons>
        </ion-toolbar>
      </ion-header>
      <ion-content fullscreen>
        <song-sheet
          v-if="songsheet.source"
          :source="songsheet.source"
          @parse="song => parsed = song"
        />
      </ion-content>
    </ion-modal>
  </app-view>
</template>
