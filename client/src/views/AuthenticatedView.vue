<script setup lang="ts">
import useAuthStore from "@/stores/auth";
import UnauthorizedView from "@/views/UnauthorizedView.vue";
import { computed, defineAsyncComponent } from "vue";

const auth = useAuthStore();
const props = defineProps<{
  component: Parameters<typeof defineAsyncComponent>[0];
}>();

const component = computed(() => {
  return auth.isAuthenticated ? defineAsyncComponent(props.component) : UnauthorizedView;
});
</script>

<template>
  <component :is="component" v-bind="$attrs" />
</template>
