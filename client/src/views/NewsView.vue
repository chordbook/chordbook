<template>
  <app-view>
    <Head>
      <title>What's New</title>
      <meta
        name="description"
        content="The latest news and updates from the community."
      >
    </Head>
    <ion-header>
      <ion-buttons slot="start">
        <ion-menu-button />
      </ion-buttons>
      <ion-toolbar>
        <ion-title>What's New</ion-title>
      </ion-toolbar>
    </ion-header>
    <ion-content>
      <ion-header collapse="condense">
        <ion-buttons slot="start">
          <ion-menu-button />
        </ion-buttons>
        <ion-toolbar>
          <ion-title size="large">
            What's New
          </ion-title>
        </ion-toolbar>
      </ion-header>
      <div>
        <data-source
          v-slot="{ data }"
          src="changelog"
        >
          <!-- eslint-disable vue/no-v-html -->
          <div
            class="ion-padding prose dark:prose-invert prose-h1:text-2xl prose-h1:border-b dark:prose-h1:border-slate-700 prose-h2:text-xl"
            v-html="data"
          />
        </data-source>
      </div>
    </ion-content>
  </app-view>
</template>

<style scoped>
.ion-padding {
  /* @apply md:p-4 md:scroll-m-4 lg:p-8 lg:scroll-m-8 xl:p-12 xl:scroll-m-12; */
}

img {
  float: right;
}
</style>
