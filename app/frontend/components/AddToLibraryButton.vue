<script setup>
import { defineProps, ref, unref, watch } from 'vue'
import { useFetch } from '@/client'
import useAuthStore from '@/stores/auth'
import { toastController } from '@ionic/vue'
import AuthRequired from '@/components/AuthRequired.vue'
import * as icons from '@/icons'

const props = defineProps({
  uid: {
    type: String,
    required: true
  }
})

const auth = useAuthStore()
const exists = ref(false)

watch(
  () => auth.isAuthenticated,
  () => {
    if (!auth.isAuthenticated) return
    useFetch('library', { params: props }).then(({ statusCode }) => {
      exists.value = unref(statusCode) === 200
    })
  },
  { immediate: true }
)

async function toast (message) {
  const toast = await toastController.create({ message, duration: 3000 })
  toast.present()
}

function add () {
  useFetch('library').post(props).then(async () => {
    exists.value = true
    toast('Added to your library')
  })
}

function remove () {
  useFetch('library').delete(props).then(() => {
    exists.value = false
    toast('Removed from your library')
  })
}
</script>

<template>
  <auth-required>
    <ion-button
      v-if="exists"
      color="success"
      @click="remove"
    >
      <ion-icon
        slot="icon-only"
        :icon="icons.saved"
      />
    </ion-button>

    <ion-button
      v-else
      @click="add"
    >
      <ion-icon
        slot="icon-only"
        :icon="icons.save"
      />
    </ion-button>
  </auth-required>
</template>
