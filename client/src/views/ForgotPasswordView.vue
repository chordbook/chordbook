<script setup lang="ts">
import useAuthStore from "@/stores/auth";
import { ref } from "vue";

const auth = useAuthStore();
const params = ref<Record<string, string>>({});

const { isFinished, error, execute, data } = auth.forgotPassword(params, {
  immediate: false,
});
</script>

<template>
  <IonPage>
    <Head>
      <title>Forgot Password</title>
    </Head>
    <IonHeader>
      <IonToolbar>
        <IonTitle> Reset Password </IonTitle>
        <IonButtons slot="end">
          <IonBackButton role="cancel" icon="" text="Cancel" default-href="/" />
        </IonButtons>
      </IonToolbar>
    </IonHeader>
    <IonContent>
      <div class="max-w-md m-auto flex flex-col justify-center h-full main-content">
        <div v-if="isFinished && !error" class="text-center">
          <p class="text-lg">
            {{ data.message }}
          </p>
        </div>
        <form v-else @submit.prevent="execute(false)">
          <IonItem>
            <IonInput
              v-model="params.email"
              label="Email"
              label-placement="floating"
              type="email"
              autocomplete="email"
              required
              :class="{ 'ion-invalid ion-touched': error }"
              :error-text="data?.error?.message"
            />
          </IonItem>
          <div class="ion-margin">
            <IonButton type="submit" expand="block"> Reset Password </IonButton>
          </div>
          <div class="ion-margin text-center text-sm text-muted">
            <RouterLink to="#signin"> Sign In </RouterLink>
            •
            <RouterLink to="#signup"> Sign Up </RouterLink>
          </div>
        </form>
      </div>
    </IonContent>
  </IonPage>
</template>
