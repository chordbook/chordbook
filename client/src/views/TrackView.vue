<script setup>
import SongsheetItem from '@/components/SongsheetItem.vue'
import { useRouter } from 'vue-router'

const router = useRouter()

defineProps({
  id: {
    type: String,
    required: true
  }
})

function loaded ({ data }) {
  // Redirect to the only version if there is only one
  if (data.value.length === 1) {
    const [{ id }] = data.value
    router.replace(`/songsheets/${id}`)
  }
}
</script>

<template>
  <app-view>
    <Head>
      <title>Versions</title>
    </Head>
    <ion-header>
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button
            text=""
            default-href="/"
          />
        </ion-buttons>
        <ion-title>Versions</ion-title>
      </ion-toolbar>
    </ion-header>
    <ion-content>
      <ion-list>
        <data-source
          v-slot="{ items }"
          :src="`tracks/${id}/songsheets`"
          @load="loaded"
          paginate
        >
          <songsheet-item
            v-for="songsheet in items"
            :key="songsheet.id"
            v-bind="songsheet"
          />
        </data-source>
      </ion-list>
    </ion-content>
  </app-view>
</template>
