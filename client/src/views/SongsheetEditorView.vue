<script setup lang="ts">
import SongsheetEditor from "@/components/Editor";
import EditorSplitView from "@/components/EditorSplitView.vue";
import SongsheetContent from "@/components/SongsheetContent.vue";
import { useFetch, useScrollSync, useSongsheetParser } from "@/composables";
import { alertController, loadingController } from "@ionic/vue";
import { computed, reactive, ref, toRef, useTemplateRef } from "vue";
import { useRouter } from "vue-router";

import type { Errors, SongsheetFull } from "@/api";

const props = defineProps<{ id?: string }>();

const router = useRouter();
const songsheet = ref<Partial<SongsheetFull>>({ source: "" });
const errors = ref<Errors>({});
const splitView = useTemplateRef("splitView");
const url = computed(() => (props.id ? `songsheets/${props.id}` : "songsheets"));
const parser = reactive(useSongsheetParser(toRef(() => songsheet.value?.source ?? "")));
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

useScrollSync(
  computed(() => editor.value?.scroller),
  preview,
);

async function save() {
  const { metadata } = parser.song?.metadata || {};
  const method = props.id ? "patch" : "post";
  const payload = {
    songsheet: {
      source: songsheet.value?.source,
      metadata,
    },
  };

  const { error, data } = await useFetch(url, { updateDataOnError: true }).json()[method](payload);

  if (error.value) {
    console.error("Songsheet could not be saved", data.value);
    errors.value = data.value;
  } else {
    router.replace({ name: "songsheet", params: { id: data.value.id } });
  }
  splitView.value?.toggle();
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
  <AppView>
    <Head>
      <title v-if="id">Edit: {{ songsheet?.title }}</title>
      <title v-else>New Song</title>
    </Head>
    <IonHeader translucent>
      <IonToolbar>
        <IonButtons slot="secondary">
          <IonBackButton text="Cancel" :default-href="id ? `/songsheets/${id}` : '/songsheets'" />
        </IonButtons>

        <IonButtons slot="primary">
          <IonButton v-if="splitView?.disabled" @click="splitView?.toggle()">
            <IonLabel>Preview</IonLabel>
          </IonButton>
          <IonButton v-else @click="save">
            <IonLabel>Save</IonLabel>
          </IonButton>
        </IonButtons>
      </IonToolbar>
    </IonHeader>
    <IonContent fullscreen :scroll-y="false" :scroll-x="false">
      <div v-if="Object.keys(errors).length">
        <ul class="px-8 py-4 text-red-600">
          <li v-for="(messages, attr) in errors" :key="attr">
            {{ attr }} {{ messages.join(", ") }}
          </li>
        </ul>
      </div>

      <EditorSplitView ref="splitView" :disabled="true">
        <template #left>
          <SongsheetEditor ref="editor" v-model="songsheet.source" :error="parser.error" />
        </template>
        <template #right-toolbar="{ toggle }">
          <IonToolbar>
            <IonTitle>Preview</IonTitle>

            <IonButtons slot="secondary">
              <IonBackButton text="Edit" :default-href="$route.fullPath" @click="toggle()" />
            </IonButtons>

            <IonButtons slot="primary">
              <IonButton @click="save">
                <IonLabel>Save</IonLabel>
              </IonButton>
            </IonButtons>
          </IonToolbar>
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
            <SongsheetContent v-if="parser.song" :song="parser.song" />
          </div>
        </template>
      </EditorSplitView>
    </IonContent>
    <IonFooter>
      <IonToolbar>
        <IonButtons slot="secondary">
          <IonButton v-if="id" fill="clear" color="danger" @click="destroy"> Delete </IonButton>
        </IonButtons>
      </IonToolbar>
    </IonFooter>
  </AppView>
</template>

<style>
.cm-content {
  @apply p-4 lg:text-base md:text-sm;
}
</style>
