<template>
  <AppView>
    <Head>
      <title>What's New</title>
      <meta name="description" content="The latest news and updates from the community." />
    </Head>
    <IonHeader>
      <IonToolbar>
        <IonButtons slot="start">
          <IonMenuButton />
        </IonButtons>
        <IonTitle>What's New</IonTitle>
      </IonToolbar>
    </IonHeader>
    <IonContent fullscreen class="main-content">
      <IonHeader collapse="condense">
        <IonButtons slot="start">
          <IonMenuButton />
        </IonButtons>
        <IonToolbar>
          <IonTitle size="large"> What's New </IonTitle>
        </IonToolbar>
      </IonHeader>
      <div>
        <DataSource v-slot="{ data }" src="changelog">
          <!-- eslint-disable vue/no-v-html -->
          <div
            class="ion-padding prose dark:prose-invert prose-h1:text-2xl prose-h1:border-b dark:prose-h1:border-slate-700 prose-h2:text-xl"
            v-html="data"
          />
        </DataSource>
      </div>
    </IonContent>
  </AppView>
</template>
