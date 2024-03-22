<script setup>
import SongsheetParser from '@/components/SongsheetParser.vue'
import SongsheetContent from '@/components/SongsheetContent.vue'
import EditorSplitView from '@/components/EditorSplitView.vue'
import SongsheetEditor from '@/components/Editor.js'
import ChordSheetJS from 'chordsheetjs'
import detectFormat from '@/lib/detect_format'
import { useFetch } from '@/client'
import { alertController, loadingController } from '@ionic/vue'
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
const preview = ref(null) // template ref
const splitView = ref(null) // template ref
const url = computed(() => props.id ? `songsheets/${props.id}` : 'songsheets')

if (props.id) {
  useFetch(`songsheets/${props.id}`).get().json().then(({ data }) => {
    songsheet.value = data.value
  })
}

async function save () {
  const { metadata } = preview.value.song.metadata
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
  splitView.value.toggle()
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

function paste (event) {
  const text = event.clipboardData.getData('text/plain')
  const format = detectFormat(text)

  // No need to convert if it's already in chordpro
  if (!format || format instanceof ChordSheetJS.ChordProParser) return

  // Stop the paste event
  event.preventDefault()

  // Convert to ChordPro
  songsheet.value.source = new ChordSheetJS.ChordProFormatter().format(format.parse(text))
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
          <ion-button
            v-if="splitView?.disabled"
            @click="splitView.toggle()"
          >
            <ion-label>Preview</ion-label>
          </ion-button>
          <ion-button
            v-else
            @click="save"
          >
            <ion-label>Save</ion-label>
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

      <editor-split-view
        ref="splitView"
        :disabled="true"
      >
        <template #left>
          <songsheet-editor
            ref="editor"
            v-model="songsheet.source"
            @paste="paste"
          />
        </template>
        <template #right-toolbar="{ toggle }">
          <ion-toolbar>
            <ion-title>Preview</ion-title>

            <ion-buttons slot="secondary">
              <ion-back-button
                text="Edit"
                :default-href="$route.fullPath"
                @click="toggle()"
              />
            </ion-buttons>

            <ion-buttons slot="primary">
              <ion-button @click="save">
                <ion-label>Save</ion-label>
              </ion-button>
            </ion-buttons>
          </ion-toolbar>
        </template>
        <template #right>
          <div class="ion-padding">
            <h3>Preview</h3>
            <songsheet-parser
              v-if="songsheet.source"
              ref="preview"
              v-slot="{ song }"
              :source="songsheet.source"
            >
              <songsheet-content :song="song" />
            </songsheet-parser>
          </div>
        </template>
      </editor-split-view>
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
  </app-view>
</template>

<style>
.cm-content {
  @apply p-4 lg:text-base md:text-sm;
}
</style>
