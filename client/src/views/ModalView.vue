<script setup>
import { defineAsyncComponent, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()

const routes = {
  '#signin': () => import('./UserSigninModal.vue'),
  '#signup': () => import('./UserSignupModal.vue'),
  '#chords': () => import('./ChordsModal.vue'),
  '#tuner': () => import('./TunerModal.vue')
}

const component = computed(() => routes[route.hash])
</script>

<template>
  <component
    v-if="component"
    :is="defineAsyncComponent(component)"
    can-dismiss
    :is-open="true"
    :presenting-element="$parent.$refs.ionRouterOutlet"
    @did-dismiss="router.back()"
  />
</template>
