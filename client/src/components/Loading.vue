<template>
  <Suspense>
    <template #default>
      <slot />
    </template>
    <template #fallback>
      <IonContent>
        <div class="flex flex-col justify-center items-center text-center min-h-screen py-8">
          <IonSpinner name="dots" color="medium" class="scale-[2]" duration="1200" />
        </div>
      </IonContent>
    </template>
  </Suspense>
</template>
