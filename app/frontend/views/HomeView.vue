<script setup>
import { IonPage, IonContent, IonCard, IonCardHeader, IonCardSubtitle, IonCardTitle, IonCardContent, IonIcon, IonButton } from '@ionic/vue'
import { logoGithub, handLeft, cashOutline } from 'ionicons/icons'
import ColorizedImg from '@/components/ColorizedImg.vue'
</script>

<template>
  <ion-page>
    <ion-content>
      <div
        class="ion-padding bg-black text-shadow min-h-screen-2/3 shadow-inner bg-center bg-cover flex flex-col place-content-center text-center"
        style="background-image: url(https://images.pexels.com/photos/144428/pexels-photo-144428.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260)"
      >
        <h1 class="text-6xl sm:text-8xl text-white/90 font-semibold">
          Just music,<br>no bullshit.
        </h1>
        <h2 class="text-xl sm:text-2xl text-white font-normal">
          Chord sheets and tab for guitar and ukulele.<br>
          Made for amateur musicians by amateur musicians.
        </h2>
      </div>

      <div
        id="contribute"
        class="lg:px-8"
      >
        <div class="text-center mt-10 sm:mt-20 ion-padding">
          <h2 class="ion-margin text-4xl sm:text-5xl">
            Let's play music better, together.
          </h2>
          <p class="text-2xl max-w-4xl mx-auto opacity-80">
            Chord Book is made by amateur musicians and volunteers. Here's how you can lend your talent, time, or money to help us continue making it better…
          </p>
        </div>

        <div class="grid md:grid-cols-3 mb-6">
          <ion-card class="flex flex-col">
            <colorized-img
              class="aspect-16/9 w-full"
              src="https://images.pexels.com/photos/1407322/pexels-photo-1407322.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=720"
            />

            <ion-card-header>
              <ion-card-subtitle>Musicians</ion-card-subtitle>
              <ion-card-title>Create & Improve Charts</ion-card-title>
            </ion-card-header>
            <ion-card-content class="grow">
              <p>
                Volunteer to be an editor and get full access to add new charts or make corrections to existing ones.
              </p>
            </ion-card-content>
            <p class="text-center">
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
            <p class="text-center">
              <ion-button
                class="w-40"
                href="https://github.com/bkeepers/chordbook"
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
                This app is open source! Fix bugs, improve features, and help us make progress on our <a href="https://github.com/bkeepers/chordbook/projects/1">roadmap</a>.
              </p>
            </ion-card-content>
            <p class="text-center">
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
  </ion-page>
</template>
