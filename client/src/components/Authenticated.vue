<script setup>
import useAuthStore from "@/stores/auth";
import UnauthorizedView from "@/views/UnauthorizedView.vue";
const auth = useAuthStore();
</script>

<template>
  <slot v-if="auth.isAuthenticated" />
  <unauthorized-view v-else />
</template>
