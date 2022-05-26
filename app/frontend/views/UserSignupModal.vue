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
  IonBackButton
} from '@ionic/vue'
import useAuthStore from '@/stores/auth'
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()
const form = ref({ user: {} })
const { execute, error, data } = auth.signUp(form, { immediate: false })

const isOpen = computed(() => !auth.isAuthenticated && route.hash === '#signup')
function dismissed () {
  if (isOpen.value) router.back()
}
</script>

<template>
  <ion-modal
    :is-open="isOpen"
    can-dismiss
    :presenting-element="$parent.$refs.ionRouterOutlet"
    @did-dismiss="dismissed"
  >
    <ion-page>
      <ion-header>
        <ion-toolbar>
          <ion-title>Sign Up</ion-title>
          <ion-buttons slot="end">
            <ion-back-button
              role="cancel"
              icon=""
              text="Cancel"
              :default-href="route.path"
            />
          </ion-buttons>
        </ion-toolbar>
      </ion-header>
      <ion-content>
        <form @submit.prevent="execute">
          <Transition name="slide-down">
            <div
              v-if="error"
              class="ion-padding text-red-500"
            >
              {{ data?.error }}
            </div>
          </Transition>
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
              type="password"
              name="password"
              autocomplete="password"
            />
          </ion-item>

          <div class="ion-margin">
            <ion-button
              type="submit"
              expand="block"
            >
              Sign Up
            </ion-button>
          </div>
          <div class="ion-margin text-center text-sm text-muted">
            Already have an account?
            <router-link to="#signin">
              Sign In
            </router-link>
          </div>
        </form>
      </ion-content>
    </ion-page>
  </ion-modal>
</template>
