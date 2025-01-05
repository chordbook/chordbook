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
  <IonModal>
    <IonPage>
      <Head>
        <title>Sign Up</title>
      </Head>
      <IonHeader>
        <IonToolbar>
          <IonTitle>Sign Up</IonTitle>
          <IonButtons slot="end">
            <IonBackButton role="cancel" icon="" text="Cancel" :default-href="route.path" />
          </IonButtons>
        </IonToolbar>
      </IonHeader>
      <IonContent color="light">
        <form @submit.prevent="execute(false)">
          <Transition name="slide-down">
            <div v-if="data?.error?.message" class="ion-padding text-red-500">
              {{ data.error.message }}
            </div>
          </Transition>
          <IonList inset>
            <IonItem>
              <IonInput
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
            </IonItem>
            <IonItem>
              <IonInput
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
            </IonItem>
            <IonItem>
              <IonInput
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
            </IonItem>
          </IonList>
          <div class="ion-margin">
            <IonButton type="submit" expand="block"> Sign Up </IonButton>
          </div>
        </form>

        <hr class="my-8" />

        <div class="ion-margin text-center">
          <h2 class="font-semibold text-lg">Already have an account?</h2>

          <div class="ion-margin">
            <IonButton fill="outline" router-link="#signin"> Sign in to your account </IonButton>
          </div>
        </div>
      </IonContent>
    </IonPage>
  </IonModal>
</template>
