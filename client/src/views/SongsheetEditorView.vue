<script setup>
import SongsheetContent from "@/components/SongsheetContent.vue";
import EditorSplitView from "@/components/EditorSplitView.vue";
import SongsheetEditor from "@/components/Editor";
import { alertController, loadingController } from "@ionic/vue";
import { ref, computed, reactive, toRef } from "vue";
import { useFetch } from "@/client";
import { useRouter } from "vue-router";
import { useSongsheetParser, useScrollSync } from "@/composables";

const props = defineProps({
  id: {
    type: String,
    default: null,
  },
});

const router = useRouter();
const songsheet = ref({ source: "" });
const errors = ref({});
const splitView = ref(null); // template ref
const url = computed(() =>
  props.id ? `songsheets/${props.id}` : "songsheets",
);
const parser = reactive(
  useSongsheetParser(toRef(() => songsheet.value.source)),
);
const editor = ref(); // template ref
const preview = ref(); // template ref

if (props.id) {
  useFetch(`songsheets/${props.id}`)
    .get()
    .json()
    .then(({ data }) => {
      songsheet.value = data.value;
    });
}

useScrollSync(computed(() => editor.value?.scroller), preview);

async function save() {
  const { metadata } = parser.song?.metadata || {};
  const method = props.id ? "patch" : "post";
  const payload = {
    songsheet: {
      source: songsheet.value.source,
      metadata,
    },
  };

  const { error, data } = await useFetch(url).json()[method](payload);

  if (error.value) {
    console.error(error.value);
    errors.value = data.value;
  } else {
    router.replace({ name: "songsheet", params: { id: data.value.id } });
  }
  splitView.value.toggle();
}

async function destroy() {
  const alert = await alertController.create({
    header: "Are you sure?",
    message: "Do you want to delete this song?",
    buttons: [
      {
        text: "Cancel",
        role: "cancel",
      },
      {
        text: "Delete",
        role: "destructive",
        handler: async () => {
          const loading = await loadingController.create({
            message: "Deleting…",
            duration: 5000,
            translucent: true,
          });
          await loading.present();
          await useFetch(url).delete();
          router.go(-2);
          loading.dismiss();
        },
      },
    ],
  });
  return alert.present();
}
</script>

<template>
  <app-view>
    <Head>
      <title v-if="id">Edit: {{ songsheet.title }}</title>
      <title v-else>New Song</title>
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
          <ion-button v-if="splitView?.disabled" @click="splitView.toggle()">
            <ion-label>Preview</ion-label>
          </ion-button>
          <ion-button v-else @click="save">
            <ion-label>Save</ion-label>
          </ion-button>
        </ion-buttons>
      </ion-toolbar>
    </ion-header>
    <ion-content fullscreen :scroll-y="false" :scroll-x="false">
      <div v-if="Object.keys(errors).length">
        <ul class="px-8 py-4 text-red-600">
          <li v-for="(messages, attr) in errors" :key="attr">
            {{ attr }} {{ messages.join(", ") }}
          </li>
        </ul>
      </div>

      <editor-split-view ref="splitView" :disabled="true">
        <template #left>
          <songsheet-editor
            ref="editor"
            v-model="songsheet.source"
            :error="parser.error"
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
          <div
            ref="preview"
            :class="{
              'ion-padding': true,
              'h-full overflow-auto main-content-padding': !splitView?.disabled,
            }"
          >
            <h3>Preview</h3>
            <songsheet-content v-if="parser.song" :song="parser.song" />
          </div>
        </template>
      </editor-split-view>
    </ion-content>
    <ion-footer>
      <ion-toolbar>
        <ion-buttons slot="secondary">
          <ion-button v-if="id" fill="clear" color="danger" @click="destroy">
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
