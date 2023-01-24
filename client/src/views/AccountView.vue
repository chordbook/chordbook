<script setup>
import * as icons from '@/icons'
import useAuthStore from '@/stores/auth'

const auth = useAuthStore()
</script>

<template>
  <app-view>
    <ion-header>
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-back-button
            text=""
            default-href="/home"
          />
        </ion-buttons>
        <ion-title>Account</ion-title>
      </ion-toolbar>
      <ion-content fullscreen>
        <ion-list>
          <ion-item class="item-label-stacked">
            <ion-label position="stacked">
              Name
            </ion-label>
            <ion-label>{{ auth.user.name }}</ion-label>
          </ion-item>
          <ion-item class="item-label-stacked">
            <ion-label position="stacked">
              Email
            </ion-label>
            <ion-label>{{ auth.user.email }}</ion-label>
          </ion-item>
        </ion-list>
        <div class="ion-padding">
          <ion-button
            class="mx-auto"
            color="medium"
            fill="outline"
            @click="auth.signOut"
          >
            <ion-icon
              slot="start"
              :icon="icons.signout"
            />
            Sign Out
          </ion-button>
        </div>
      </ion-content>
    </ion-header>
  </app-view>
</template>
