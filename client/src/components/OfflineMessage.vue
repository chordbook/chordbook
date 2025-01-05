<template>
  <IonHeader translucent>
    <IonToolbar>
      <IonButtons slot="start">
        <IonBackButton text="" default-href="/" />
      </IonButtons>
    </IonToolbar>
  </IonHeader>
  <IonContent>
    <BlankSlate
      icon="offline"
      title="Not available offline"
      description="Try again when you are online and it will be available offline next time."
    />
  </IonContent>
</template>
