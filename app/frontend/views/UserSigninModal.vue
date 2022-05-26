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
const form = ref({})
const { execute, error, data } = auth.signIn(form, { immediate: false })

const isOpen = computed(() => route.hash === '#signin' && !auth.isAuthenticated)
function dismissed () {
  if (isOpen.value) router.back()
}
</script>

<template>
  <ion-modal
    :is-open="isOpen"
    can-dismiss
    :presenting-element="$parent.$refs.ionRouterOutlet"
    @did-dismiss="dismissed()"
  >
    <ion-page>
      <ion-header>
        <ion-toolbar>
          <ion-title>Sign In</ion-title>
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
              v-model="form.email"
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
              v-model="form.password"
              type="password"
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
          <div class="ion-margin text-center text-sm text-muted">
            <router-link to="#signup">
              Sign Up
            </router-link>
            •
            <router-link to="#password">
              Forgot Password
            </router-link>
          </div>
        </form>
      </ion-content>
    </ion-page>
  </ion-modal>
</template>
