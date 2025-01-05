<template>
  <IonPage>
    <IonContent>
      <div class="flex flex-col justify-center items-center text-center h-full">
        <h2 class="mb-1">
          <div class="text-sm uppercase text-muted tracking-widest">Sign in to your account to</div>
          <div class="font-semibold text-3xl">Build Your Repertoire.</div>
        </h2>
        <p class="text-muted">Save songs, artists, and setlists to your library.</p>

        <div class="grid grid-cols-2 mt-8 gap-12 text-center">
          <div>
            <p class="text-muted">Have an account?</p>
            <IonButton fill="outline" router-link="#signin"> Sign In </IonButton>
          </div>
          <div>
            <p class="text-muted">Join now for free.</p>
            <IonButton router-link="#signup"> Sign Up </IonButton>
          </div>
        </div>
      </div>
    </IonContent>
  </IonPage>
</template>
