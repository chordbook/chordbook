<script setup lang="ts">
import useAuthStore from "@/stores/auth";
import { ref, watchEffect } from "vue";
import { useRoute, useRouter } from "vue-router";

const route = useRoute();
const router = useRouter();
const auth = useAuthStore();
const form = ref({ email: "", password: "" });
const { execute, data, isFetching } = auth.signIn(form, { immediate: false });

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
        <title>Sign In</title>
      </Head>
      <IonHeader>
        <IonToolbar>
          <IonTitle>Sign In</IonTitle>
          <IonButtons slot="end">
            <IonBackButton role="cancel" icon="" text="Cancel" :default-href="route.path" />
          </IonButtons>
        </IonToolbar>
      </IonHeader>
      <IonContent color="light">
        <form @submit.prevent="execute(false)">
          <div v-if="!isFetching && data?.error?.message" class="ion-padding text-red-500">
            {{ data.error.message }}
          </div>
          <IonList inset>
            <IonItem>
              <IonInput
                v-model="form.email"
                label="Email"
                label-placement="floating"
                type="email"
                autocomplete="email"
                placeholder="Your email"
              />
            </IonItem>
            <IonItem>
              <IonInput
                v-model="form.password"
                label="Password"
                label-placement="floating"
                type="password"
                autocomplete="current-password"
                placeholder="Your password"
              />
            </IonItem>
          </IonList>
          <div class="ion-margin">
            <IonButton type="submit" expand="block"> Sign In </IonButton>
          </div>
          <RouterLink
            :to="{ name: 'password/forgot' }"
            class="text-muted text-sm text-center block"
          >
            Forgot your password?
          </RouterLink>
          <div class="ion-margin text-center text-sm text-muted" />
        </form>

        <hr class="my-10" />

        <div class="ion-margin text-center">
          <h2 class="font-semibold text-lg">Don't have an account?</h2>

          <div class="ion-margin">
            <IonButton fill="outline" router-link="#signup"> Sign up for Chord Book </IonButton>
          </div>
        </div>
      </IonContent>
    </IonPage>
  </IonModal>
</template>
