<script lang="ts" setup>
import ColorizedImg from "@/components/ColorizedImg.vue";

defineProps<{
  image: string;
  title: string;
  audience: string;
  icon: string;
  buttonText: string;
  url: string;
}>();
</script>
<template>
  <IonCard class="flex flex-col sm:max-xl:flex-row m-0">
    <ColorizedImg
      class="aspect-16/9 w-full sm:max-xl:aspect-square sm:max-xl:h-60 sm:max-xl:w-60"
      :src="image"
    />
    <div>
      <IonCardHeader>
        <IonCardSubtitle>{{ audience }}</IonCardSubtitle>
        <IonCardTitle>{{ title }}</IonCardTitle>
      </IonCardHeader>
      <IonCardContent class="grow flex flex-col gap-4">
        <p>
          <slot />
        </p>
        <p class="lg:text-center">
          <IonButton class="w-40" :href="url">
            <IonIcon slot="start" :icon="icon" />
            {{ buttonText }}
          </IonButton>
        </p>
      </IonCardContent>
    </div>
  </IonCard>
</template>
