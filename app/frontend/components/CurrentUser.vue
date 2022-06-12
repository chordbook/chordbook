<script setup>
import useAuthStore from '@/stores/auth'
import * as icons from '@/icons'

const auth = useAuthStore()
</script>
<template>
  <div v-if="auth.isAuthenticated">
    <ion-chip id="current-user">
      <ion-avatar>
        <img :src="icons.avatar">
      </ion-avatar>
      <ion-label>{{ auth.user.email }}</ion-label>
    </ion-chip>
    <ion-popover
      trigger="current-user"
      side="top"
      alignment="center"
      translucent
      dismiss-on-select
      :show-backdrop="false"
      :arrow="false"
      style="--offset-y:-5rem"
    >
      <ion-list>
        <ion-item
          lines="none"
          button
          detail
          :detail-icon="icons.signout"
          @click="auth.signOut"
        >
          Sign Out
        </ion-item>
      </ion-list>
    </ion-popover>
  </div>
  <div v-else>
    <ion-button
      color="dark"
      fill="outline"
      router-link="#signin"
    >
      Sign In
    </ion-button>
    <ion-button
      color="dark"
      fill="clear"
      router-link="#signup"
    >
      Sign Up
    </ion-button>
  </div>
</template>
