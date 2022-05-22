<script setup>
import {
  IonButton,
  IonButtons,
  IonContent,
  IonHeader,
  IonInput,
  IonItem,
  IonLabel,
  IonModal,
  IonPage,
  IonTitle,
  IonToolbar,
  modalController
} from '@ionic/vue'
import useAuthStore from '@/stores/auth'
import {
  ref,
  watch
} from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const auth = useAuthStore()
const form = ref({ user: {} })
const { execute, error, data } = auth.signIn(form, { immediate: false })

watch(
  () => auth.isAuthenticated,
  () => {
    if (auth.isAuthenticated) {
      router.push({ name: 'home' })
    }
  },
  { immediate: true }
)
</script>

<template>
  <ion-modal
    :is-open="true"
    can-dismiss
    :presenting-element="$parent.$refs.ionRouterOutlet"
  >
    <ion-page>
      <ion-header>
        <ion-toolbar>
          <ion-title>Sign In</ion-title>
          <ion-buttons slot="end">
            <ion-button
              role="cancel"
              @click="modalController.dismiss()"
            >
              Cancel
            </ion-button>
          </ion-buttons>
        </ion-toolbar>
      </ion-header>
      <ion-content>
        <form @submit.prevent="execute">
          <div
            v-if="error"
            class="ion-padding text-red-500"
          >
            {{ data.error }}
          </div>
          <ion-item>
            <ion-label position="floating">
              Email
            </ion-label>
            <ion-input
              v-model="form.user.email"
              type="text"
              name="email"
              autocomplete="email"
            />
          </ion-item>
          <ion-item>
            <ion-label position="floating">
              Password
            </ion-label>
            <ion-input
              v-model="form.user.password"
              type="text"
              name="password"
              autocomplete="password"
            />
          </ion-item>

          <div class="ion-margin ">
            <ion-button
              type="submit"
              expand="block"
            >
              Sign In
            </ion-button>
          </div>
          <div class="ion-margin text-center">
            <router-link :to="{name: 'signup' }">
              Sign Up
            </router-link>
            •
            <router-link :to="{name: 'signup' }">
              Forgot Password
            </router-link>
          </div>
        </form>
      </ion-content>
    </ion-page>
  </ion-modal>
</template>
