<script setup>
import useAuthStore from '@/stores/auth'
import { ref } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const auth = useAuthStore()
const form = ref({ user: {} })
const { execute, data } = auth.signUp(form, { immediate: false })
</script>

<template>
  <ion-modal>
    <ion-page>
      <Head>
        <title>Sign Up</title>
      </Head>
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
            <ion-label position="stacked">
              Name
            </ion-label>
            <ion-input
              v-model="form.user.name"
              type="text"
              autocomplete="name"
              required
              placeholder="Your name"
            />
            <ion-note slot="error">
              {{ data?.error?.name?.join(', ') }}
            </ion-note>
          </ion-item>
          <ion-item :class="{ 'ion-invalid': data?.error?.email }">
            <ion-label position="stacked">
              Email
            </ion-label>
            <ion-input
              v-model="form.user.email"
              type="email"
              autocomplete="email"
              placeholder="Your email"
            />
            <ion-note slot="error">
              {{ data?.error?.email?.join(', ') }}
            </ion-note>
          </ion-item>
          <ion-item :class="{ 'ion-invalid': data?.error?.password }">
            <ion-label position="stacked">
              Password
            </ion-label>
            <ion-input
              v-model="form.user.password"
              type="password"
              autocomplete="new-password"
              placeholder="Create a password"
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
        </form>

        <hr class="my-8">

        <div class="ion-margin text-center">
          <h2 class="font-semibold text-lg">
            Already have an account?
          </h2>

          <div class="ion-margin">
            <ion-button
              fill="outline"
              router-link="#signin"
            >
              Sign in to your account
            </ion-button>
          </div>
        </div>
      </ion-content>
    </ion-page>
  </ion-modal>
</template>
