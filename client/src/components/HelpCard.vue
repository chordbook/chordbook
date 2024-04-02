<script setup>
import ColorizedImg from '@/components/ColorizedImg.vue'

defineProps({
  image: {
    type: String,
    required: true
  },
  title: {
    type: String,
    required: true
  },
  audience: {
    type: String,
    required: true
  },
  icon: {
    type: String,
    required: true
  },
  buttonText: {
    type: String,
    required: true
  },
  url: {
    type: String,
    required: true
  }

})
</script>
<template>
  <ion-card class="flex flex-col sm:max-xl:flex-row m-0">
    <colorized-img
      class="aspect-16/9 w-full sm:max-xl:aspect-square sm:max-xl:h-60 sm:max-xl:w-60"
      :src="image"
    />
    <div>
      <ion-card-header>
        <ion-card-subtitle>{{ audience }}</ion-card-subtitle>
        <ion-card-title>{{ title }}</ion-card-title>
      </ion-card-header>
      <ion-card-content class="grow flex flex-col gap-4">
        <p>
          <slot />
        </p>
        <p class="lg:text-center">
          <ion-button
            class="w-40"
            :href="url"
          >
            <ion-icon
              slot="start"
              :icon="icon"
            />
            {{ buttonText }}
          </ion-button>
        </p>
      </ion-card-content>
    </div>
  </ion-card>
</template>
