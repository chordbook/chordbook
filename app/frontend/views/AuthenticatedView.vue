<script setup>
import useAuthStore from '@/stores/auth'
import UnauthorizedView from '@/views/UnauthorizedView.vue'
import { defineAsyncComponent, computed } from 'vue'

const auth = useAuthStore()
const props = defineProps({
  component: {
    type: Function,
    required: true
  }
})

const component = computed(() => {
  return auth.isAuthenticated ? defineAsyncComponent(props.component) : UnauthorizedView
})
</script>

<template>
  <component
    :is="component"
    v-bind="$attrs"
  />
</template>
