<script lang="ts" setup>
import { modalController } from "@ionic/vue";
import { useFetch } from "@/client";
import { reactive } from "vue";

const params = reactive<{ title?: string, description?: string }>({});

async function save() {
  const { data } = await useFetch("setlists").post({ setlist: params }).json();
  modalController.dismiss(data);
}
</script>

<template>
  <ion-header>
    <ion-toolbar>
      <ion-title>New Setlist</ion-title>
      <ion-buttons slot="start">
        <ion-button role="cancel" @click="modalController.dismiss()">
          Cancel
        </ion-button>
      </ion-buttons>
    </ion-toolbar>
  </ion-header>
  <ion-content>
    <ion-item>
      <ion-label position="stacked"> Setlist title </ion-label>
      <ion-input v-model="params.title" />
    </ion-item>

    <ion-item>
      <ion-label position="stacked"> Description </ion-label>
      <ion-textarea v-model="params.description" />
    </ion-item>

    <div class="ion-padding">
      <ion-button expand="block" type="submit" @click="save"> Save </ion-button>
    </div>
  </ion-content>
</template>
