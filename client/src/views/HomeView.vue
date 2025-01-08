<script setup lang="ts">
import { DataSource } from "@/components";
import HelpCard from "@/components/HelpCard.vue";
import * as icons from "@/icons";
import useAuthStore from "@/stores/auth";
import { cashOutline, handLeft, logoGithub } from "ionicons/icons";

import type { Home } from "@/api";

const auth = useAuthStore();
</script>

<template>
  <AppView>
    <Head>
      <title>Home</title>
      <meta name="description" content="Chord sheets and tab for guitar and ukulele." />
    </Head>
    <IonHeader v-if="auth.isAuthenticated" collapse="fade" translucent>
      <IonToolbar>
        <IonButtons slot="start">
          <IonMenuButton />
        </IonButtons>
        <IonTitle>Home</IonTitle>
        <IonButtons slot="end">
          <IonButton router-link="/account">
            <IonIcon slot="icon-only" :icon="icons.avatar" />
          </IonButton>
        </IonButtons>
      </IonToolbar>
    </IonHeader>
    <IonHeader v-else translucent>
      <IonToolbar>
        <IonButtons slot="start">
          <IonMenuButton />
        </IonButtons>
        <IonTitle class="flex">
          <img :src="icons.logoLight" class="dark:hidden inline-block mr-3" />
          <img :src="icons.logo" class="hidden dark:inline-block mr-3" />
          <img
            alt="Chord Book"
            :src="icons.wordmarkLight"
            class="inline-block max-w-[150px] dark:hidden"
          />
          <img
            alt="Chord Book"
            class="hidden dark:inline-block max-w-[150px]"
            :src="icons.wordmark"
          />
        </IonTitle>

        <IonButtons slot="end">
          <IonButton router-link="#signin"> Sign In </IonButton>
        </IonButtons>
      </IonToolbar>
    </IonHeader>
    <IonContent fullscreen class="main-content">
      <IonHeader v-if="auth.isAuthenticated" collapse="condense">
        <IonToolbar>
          <IonTitle size="large"> Home </IonTitle>
        </IonToolbar>
      </IonHeader>
      <IonCard
        v-else
        class="bg-black aspect-square-max-h-screen-1\/2 min-h-screen-1/2 shadow-inner bg-center bg-cover flex flex-col"
        style="
          background-image: url(https://images.pexels.com/photos/144428/pexels-photo-144428.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260);
        "
      >
        <div class="my-auto text-center">
          <h2
            class="text-4xl sm:text-6xl md:text-7xl font-bold text-white font-semibold text-shadow-lg"
          >
            Play all your<br />
            favorite songs.
          </h2>

          <p class="sm:text-lg md:text-xl lg:text-2xl text-white/80 text-shadow-md mt-4">
            Chord sheets and tab for guitar and ukulele.
          </p>
        </div>
      </IonCard>

      <DataSource ref="dataSource" v-slot="{ data }" src="home">
        <div v-for="section in data as Home" :key="section.name">
          <IonListHeader>
            <IonLabel class="text-2xl">
              {{ section.name }}
            </IonLabel>
            <IonButton v-if="section.href" :router-link="section.href"> See All </IonButton>
          </IonListHeader>

          <ModelList :items="section.items" :format="section.format" />
        </div>
      </DataSource>

      <div id="contribute">
        <div class="text-center mt-10 sm:mt-20 ion-padding">
          <h2 class="ion-margin text-4xl sm:text-5xl md:text-6xl font-bold">
            Help us make music&nbsp;better.
          </h2>
          <p class="text-xl sm:text-2xl max-w-4xl mx-auto text-muted">
            Chord Book is made by amateur musicians and volunteers. Here's how you can lend your
            talent, time, or money to help make it even better…
          </p>
        </div>

        <div class="grid xl:grid-cols-3 xl:mb-6 ion-padding gap-3 md:gap-4 xl:gap-4 2xl:gap-6">
          <HelpCard
            image="https://images.pexels.com/photos/1407322/pexels-photo-1407322.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=720"
            audience="Musicians"
            title="Improve Charts"
            url="mailto:help@chordbook.app?subject=I'd%20like%20to%20volunteer"
            :icon="handLeft"
            button-text="Volunteer"
          >
            Volunteer to be an editor and get full access to add new charts or make corrections to
            existing ones.
          </HelpCard>
          <HelpCard
            image="https://images.pexels.com/photos/48171/guitar-case-street-musicians-donate-donation-48171.jpeg?auto=compress&cs=tinysrgb&w=640"
            audience="Patrons"
            title="Leave a Tip"
            url="https://www.patreon.com/chordbook"
            :icon="cashOutline"
            button-text="Donate"
          >
            Show your appreciation and support the costs of building and running the app.
          </HelpCard>
          <HelpCard
            image="https://images.pexels.com/photos/374563/pexels-photo-374563.jpeg?auto=compress&cs=tinysrgb&dpr=3w=640"
            audience="Developers"
            title="Contribute Code"
            url="https://github.com/bkeepers/chordbook"
            :icon="logoGithub"
            button-text="Contribute"
          >
            This app is open source! Help us fix bugs, improve features, and make progress on our
            <a href="https://github.com/bkeepers/chordbook/projects/1">roadmap</a>.
          </HelpCard>
        </div>
      </div>
    </IonContent>
  </AppView>
</template>
