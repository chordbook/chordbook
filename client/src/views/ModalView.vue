<script setup lang="ts">
import { defineAsyncComponent, computed } from "vue";
import { useRoute, useRouter } from "vue-router";

const route = useRoute();
const router = useRouter();
const routes: Record<string, Parameters<typeof defineAsyncComponent>[0]> = {
  "#signin": () => import("./UserSigninModal.vue"),
  "#signup": () => import("./UserSignupModal.vue"),
  "#chords": () => import("./ChordsModal.vue"),
  "#tuner": () => import("./TunerModal.vue"),
};

const component = computed(() => routes[route.hash]);
</script>

<template>
  <component
    :is="defineAsyncComponent(component)"
    v-if="component"
    can-dismiss
    :is-open="true"
    :presenting-element="$parent?.$refs.ionRouterOutlet"
    @did-dismiss="router.back()"
  />
</template>
