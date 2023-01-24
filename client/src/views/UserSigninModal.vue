<script setup>
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
            <ion-label position="stacked">
              Email
            </ion-label>
            <ion-input
              v-model="form.email"
              type="email"
              autocomplete="email"
              placeholder="Your email"
            />
          </ion-item>
          <ion-item>
            <ion-label position="stacked">
              Password
            </ion-label>
            <ion-input
              v-model="form.password"
              type="password"
              autocomplete="current-password"
              placeholder="Your password"
            />
            <ion-note slot="helper">
              <router-link :to="{ name: 'password/forgot' }">
                Forgot your password?
              </router-link>
            </ion-note>
          </ion-item>

          <div class="ion-margin ">
            <ion-button
              type="submit"
              expand="block"
            >
              Sign In
            </ion-button>
          </div>
          <div class="ion-margin text-center text-sm text-muted" />
        </form>

        <hr class="my-10">

        <div class="ion-margin text-center">
          <h2 class="font-semibold text-lg">
            Don't have an account?
          </h2>

          <div class="ion-margin">
            <ion-button
              fill="outline"
              router-link="#signup"
            >
              Sign up for Chord Book
            </ion-button>
          </div>
        </div>
      </ion-content>
    </ion-page>
  </ion-modal>
</template>
