<script setup>
import useAuthStore from '@/stores/auth'
import { useRouter } from 'vue-router'

const router = useRouter()
const auth = useAuthStore()

function ensureAuthenticated (event) {
  if (auth.isAuthenticated) return
  event.stopPropagation()
  event.preventDefault()
  router.push('#signup')
}
</script>

<template>
  <div @click.capture="ensureAuthenticated">
    <slot />
  </div>
</template>
