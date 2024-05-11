<template>
  <app-view>
    <Head>
      <title>What's New</title>
      <meta
        name="description"
        content="The latest news and updates from the community."
      />
    </Head>
    <ion-header>
      <ion-toolbar>
        <ion-buttons slot="start">
          <ion-menu-button />
        </ion-buttons>
        <ion-title>What's New</ion-title>
      </ion-toolbar>
    </ion-header>
    <ion-content fullscreen class="main-content">
      <ion-header collapse="condense">
        <ion-buttons slot="start">
          <ion-menu-button />
        </ion-buttons>
        <ion-toolbar>
          <ion-title size="large"> What's New </ion-title>
        </ion-toolbar>
      </ion-header>
      <div>
        <data-source v-slot="{ data }" src="changelog">
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
