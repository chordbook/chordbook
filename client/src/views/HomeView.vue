<script setup>
import { logoGithub, handLeft, cashOutline } from 'ionicons/icons'
import ColorizedImg from '@/components/ColorizedImg.vue'
import useAuthStore from '@/stores/auth'
import * as icons from '@/icons'

const auth = useAuthStore()
</script>

<template>
  <app-view>
    <Head>
      <title>Home</title>
      <meta
        name="description"
        content="Chord sheets and tab for guitar and ukulele."
      >
    </Head>
    <ion-header
      v-if="auth.isAuthenticated"
      collapse="fade"
      translucent
    >
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-menu-button />
        </ion-buttons>
        <ion-title>Home</ion-title>
        <ion-buttons slot="end">
          <ion-button router-link="/account">
            <ion-icon
              slot="icon-only"
              :icon="icons.avatar"
            />
          </ion-button>
        </ion-buttons>
      </ion-toolbar>
    </ion-header>
    <ion-header
      v-else
      translucent
    >
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-menu-button />
        </ion-buttons>
        <ion-title class="flex">
          <img
            :src="icons.logoLight"
            class="dark:hidden inline-block mr-3"
          >
          <img
            :src="icons.logo"
            class="hidden dark:inline-block mr-3"
          >
          <img
            alt="Chord Book"
            :src="icons.wordmarkLight"
            class="inline-block max-w-[150px] dark:hidden"
          >
          <img
            alt="Chord Book"
            class="hidden dark:inline-block max-w-[150px]"
            :src="icons.wordmark"
          >
        </ion-title>

        <ion-buttons slot="end">
          <ion-button router-link="#signin">
            Sign In
          </ion-button>
        </ion-buttons>
      </ion-toolbar>
    </ion-header>
    <ion-content fullscreen>
      <ion-header
        v-if="auth.isAuthenticated"
        collapse="condense"
      >
        <ion-toolbar>
          <ion-title size="large">
            Home
          </ion-title>
        </ion-toolbar>
      </ion-header>
      <ion-card
        v-else
        class="bg-black aspect-square-max-h-screen-1\/2 min-h-screen-1/2 shadow-inner bg-center bg-cover flex flex-col"
        style="background-image: url(https://images.pexels.com/photos/144428/pexels-photo-144428.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260)"
      >
        <div class="my-auto text-center">
          <h2 class="text-4xl sm:text-6xl md:text-7xl font-bold text-white font-semibold text-shadow-lg">
            Play all your<br>
            favorite songs.
          </h2>

          <p class="sm:text-lg md:text-xl lg:text-2xl text-white/80 text-shadow-md mt-4">
            Chord sheets and tab for guitar and ukulele.
          </p>
        </div>
      </ion-card>

      <data-source
        v-slot="{ data }"
        src="home"
      >
        <div
          v-for="section in data"
          :key="section.name"
        >
          <ion-list-header>
            <ion-label class="text-2xl">
              {{ section.name }}
            </ion-label>
            <ion-button
              v-if="section.href"
              :router-link="section.href"
            >
              See All
            </ion-button>
          </ion-list-header>

          <model-list
            :items="section.items"
            :format="section.format"
          />
        </div>
      </data-source>

      <div
        id="contribute"
        class="lg:px-8"
      >
        <div class="text-center mt-10 sm:mt-20 ion-padding">
          <h2 class="ion-margin text-4xl sm:text-5xl md:text-6xl font-bold">
            Help us make music&nbsp;better.
          </h2>
          <p class="text-xl sm:text-2xl max-w-4xl mx-auto text-muted">
            Chord Book is made by amateur musicians and volunteers. Here's how you can lend your talent, time, or money to help make it even better…
          </p>
        </div>

        <div class="grid md:grid-cols-3 md:mb-6">
          <ion-card class="flex flex-col">
            <colorized-img
              class="aspect-16/9 w-full"
              src="https://images.pexels.com/photos/1407322/pexels-photo-1407322.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=720"
            />

            <ion-card-header>
              <ion-card-subtitle>Musicians</ion-card-subtitle>
              <ion-card-title>Improve Charts</ion-card-title>
            </ion-card-header>
            <ion-card-content class="grow">
              <p>
                Volunteer to be an editor and get full access to add new charts or make corrections to existing ones.
              </p>
            </ion-card-content>
            <p class="text-center mb-4">
              <ion-button
                class="w-40"
                href="mailto:help@chordbook.app?subject=I'd%20like%20to%20volunteer"
              >
                <ion-icon
                  slot="start"
                  :icon="handLeft"
                />
                Volunteer
              </ion-button>
            </p>
          </ion-card>
          <ion-card class="flex flex-col">
            <colorized-img
              class="aspect-16/9 w-full"
              src="https://images.pexels.com/photos/48171/guitar-case-street-musicians-donate-donation-48171.jpeg?auto=compress&cs=tinysrgb&w=640"
            />
            <ion-card-header>
              <ion-card-subtitle>Patrons</ion-card-subtitle>
              <ion-card-title>Leave a Tip</ion-card-title>
            </ion-card-header>
            <ion-card-content class="grow">
              <p>
                Show your appreciation and support the costs of building and running the app.
              </p>
            </ion-card-content>
            <p class="text-center mb-4">
              <ion-button
                class="w-40"
                href="https://www.patreon.com/chordbook"
              >
                <ion-icon
                  slot="start"
                  :icon="cashOutline"
                />
                Donate
              </ion-button>
            </p>
          </ion-card>
          <ion-card class="flex flex-col">
            <colorized-img
              class="aspect-16/9 w-full"
              src="https://images.pexels.com/photos/374563/pexels-photo-374563.jpeg?auto=compress&cs=tinysrgb&dpr=3w=640"
            />

            <ion-card-header>
              <ion-card-subtitle>Developers</ion-card-subtitle>
              <ion-card-title>Contribute Code</ion-card-title>
            </ion-card-header>
            <ion-card-content class="grow">
              <p>
                This app is open source! Help us fix bugs, improve features, and make progress on our <a href="https://github.com/bkeepers/chordbook/projects/1">roadmap</a>.
              </p>
            </ion-card-content>
            <p class="text-center mb-4">
              <ion-button
                class="w-40"
                href="https://github.com/bkeepers/chordbook"
                target="_blank"
                rel="noopener"
              >
                <ion-icon
                  slot="start"
                  :icon="logoGithub"
                />
                Contribute
              </ion-button>
            </p>
          </ion-card>
        </div>
      </div>
    </ion-content>
  </app-view>
</template>
