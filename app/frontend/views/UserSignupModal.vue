<script setup>
import useAuthStore from '@/stores/auth'
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()
const form = ref({ user: {} })
const { execute, data } = auth.signUp(form, { immediate: false })

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
              v-if="data?.error?.message"
              class="ion-padding text-red-500"
            >
              {{ data?.error?.message }}
            </div>
          </Transition>
          <ion-item :class="{ 'ion-invalid': data?.error?.name }">
            <ion-label position="floating">
              Name
            </ion-label>
            <ion-input
              v-model="form.user.name"
              type="text"
              autocomplete="name"
              required
            />
            <ion-note slot="error">
              {{ data?.error?.name?.join(', ') }}
            </ion-note>
          </ion-item>
          <ion-item :class="{ 'ion-invalid': data?.error?.email }">
            <ion-label position="floating">
              Email
            </ion-label>
            <ion-input
              v-model="form.user.email"
              type="email"
              autocomplete="email"
            />
            <ion-note slot="error">
              {{ data?.error?.email?.join(', ') }}
            </ion-note>
          </ion-item>
          <ion-item :class="{ 'ion-invalid': data?.error?.password }">
            <ion-label position="floating">
              Password
            </ion-label>
            <ion-input
              v-model="form.user.password"
              type="password"
              autocomplete="new-password"
            />
            <ion-note slot="error">
              {{ data?.error?.password?.join(', ') }}
            </ion-note>
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
