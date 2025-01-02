<script setup lang="ts">
import useAuthStore from "@/stores/auth";
import { ref, watchEffect } from "vue";
import { useRoute, useRouter } from "vue-router";

import type { SignUp } from "@/api";

const route = useRoute();
const router = useRouter();
const auth = useAuthStore();
const form = ref<SignUp["user"]>({ name: "", email: "", password: "" });
const { execute, data } = auth.signUp(form, { immediate: false });

watchEffect(() => {
  if (auth.isAuthenticated) {
    router.replace({ path: route.path }); // without hash
  }
});
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
      <ion-content color="light">
        <form @submit.prevent="execute(false)">
          <Transition name="slide-down">
            <div v-if="data?.error?.message" class="ion-padding text-red-500">
              {{ data.error.message }}
            </div>
          </Transition>
          <ion-list inset>
            <ion-item>
              <ion-input
                v-model="form.name"
                label="Name"
                label-placement="floating"
                type="text"
                autocomplete="name"
                required
                placeholder="Your name"
                :error-text="data?.error?.name?.join(', ')"
                :class="{ 'ion-invalid ion-touched': data?.error?.name }"
              />
            </ion-item>
            <ion-item>
              <ion-input
                v-model="form.email"
                label="Email"
                label-placement="floating"
                type="email"
                autocomplete="email"
                required
                placeholder="Your email"
                :error-text="data?.error?.email?.join(', ')"
                :class="{ 'ion-invalid ion-touched': data?.error?.email }"
              />
            </ion-item>
            <ion-item>
              <ion-input
                v-model="form.password"
                label="Password"
                label-placement="floating"
                type="password"
                autocomplete="new-password"
                required
                placeholder="Create a password"
                :error-text="data?.error?.password"
                :class="{ 'ion-invalid ion-touched': data?.error?.password }"
              />
            </ion-item>
          </ion-list>
          <div class="ion-margin">
            <ion-button type="submit" expand="block"> Sign Up </ion-button>
          </div>
        </form>

        <hr class="my-8" />

        <div class="ion-margin text-center">
          <h2 class="font-semibold text-lg">Already have an account?</h2>

          <div class="ion-margin">
            <ion-button fill="outline" router-link="#signin">
              Sign in to your account
            </ion-button>
          </div>
        </div>
      </ion-content>
    </ion-page>
  </ion-modal>
</template>
