<script setup lang="ts">
import useAuthStore from "@/stores/auth";
import { ref } from "vue";
import { useRouter } from "vue-router";

const auth = useAuthStore();
const router = useRouter();
const props = defineProps<{
  token: string;
}>();
const params = ref({
  token: props.token,
  password: "",
});

const { execute, data, onFetchResponse } = auth.resetPassword(params, {
  immediate: false,
});

onFetchResponse(() => {
  router.push("#signin");
});
</script>

<template>
  <IonPage>
    <Head>
      <title>Reset Your Password</title>
    </Head>
    <IonHeader>
      <IonToolbar>
        <IonTitle>Reset Your Password</IonTitle>
        <IonButtons slot="end">
          <IonBackButton role="cancel" icon="" text="Cancel" default-href="#signin" />
        </IonButtons>
      </IonToolbar>
    </IonHeader>
    <IonContent>
      <div class="max-w-md m-auto flex flex-col justify-center h-full">
        <form @submit.prevent="execute(false)">
          <IonItem>
            <IonInput
              v-model="params.password"
              label="New Password"
              label-placement="floating"
              type="password"
              autocomplete="new-password"
              :class="{ 'ion-invalid ion-touched': data?.error?.password }"
              :error-text="data?.error?.password?.join(', ')"
            />
          </IonItem>

          <div class="ion-margin">
            <IonButton type="submit" expand="block"> Set Password </IonButton>
          </div>
          <div class="ion-margin text-center text-sm text-muted">
            Did you remember your password?
            <RouterLink to="#signin"> Sign In </RouterLink>
          </div>
        </form>
      </div>
      <IonAlert
        v-if="data?.error?.message"
        header="Error"
        :message="data?.error?.message"
        :buttons="['Ok']"
        @did-dismiss="router.push({ name: 'password/forgot' })"
      />
    </IonContent>
  </IonPage>
</template>
