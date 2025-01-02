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
  password: ""
});

const { execute, data, onFetchResponse } = auth.resetPassword(params, {
  immediate: false,
});

onFetchResponse(() => {
  router.push("#signin");
});
</script>

<template>
  <ion-page>
    <Head>
      <title>Reset Your Password</title>
    </Head>
    <ion-header>
      <ion-toolbar>
        <ion-title>Reset Your Password</ion-title>
        <ion-buttons slot="end">
          <ion-back-button
            role="cancel"
            icon=""
            text="Cancel"
            default-href="#signin"
          />
        </ion-buttons>
      </ion-toolbar>
    </ion-header>
    <ion-content>
      <div class="max-w-md m-auto flex flex-col justify-center h-full">
        <form @submit.prevent="execute(false)">
          <ion-item>
            <ion-input
              v-model="params.password"
              label="New Password"
              label-placement="floating"
              type="password"
              autocomplete="new-password"
              :class="{ 'ion-invalid ion-touched': data?.error?.password }"
              :error-text="data?.error?.password?.join(', ')"
            />
          </ion-item>

          <div class="ion-margin">
            <ion-button type="submit" expand="block"> Set Password </ion-button>
          </div>
          <div class="ion-margin text-center text-sm text-muted">
            Did you remember your password?
            <router-link to="#signin"> Sign In </router-link>
          </div>
        </form>
      </div>
      <ion-alert
        v-if="data?.error?.message"
        header="Error"
        :message="data?.error?.message"
        :buttons="['Ok']"
        @did-dismiss="router.push({ name: 'password/forgot' })"
      />
    </ion-content>
  </ion-page>
</template>
