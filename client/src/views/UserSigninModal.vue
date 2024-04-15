<script setup>
import useAuthStore from '@/stores/auth'
import { ref, watchEffect } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()
const form = ref({})
const { execute, data, isFetching } = auth.signIn(form, { immediate: false })

watchEffect(() => {
  if (auth.isAuthenticated) {
    router.replace({ path: route.path }) // without hash
  }
})
</script>

<template>
  <ion-modal>
    <ion-page>
      <Head>
        <title>Sign In</title>
      </Head>
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
        <form @submit.prevent="execute(false)">
          <div
            v-if="!isFetching && data?.error?.message"
            class="ion-padding text-red-500"
          >
            {{ data.error.message }}
          </div>
          <ion-item>
            <ion-input
              v-model="form.email"
              label="Email"
              label-placement="floating"
              type="email"
              autocomplete="email"
              placeholder="Your email"
            />
          </ion-item>
          <ion-item>
            <ion-input
              v-model="form.password"
              label="Password"
              label-placement="floating"
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
