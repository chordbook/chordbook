<template>
  <Suspense>
    <template #default>
      <slot />
    </template>
    <template #fallback>
      <ion-content>
        <div class="flex flex-col justify-center items-center text-center min-h-screen py-8">
          <ion-spinner
            name="dots"
            color="medium"
            class="scale-150"
            duration="1500"
          />
        </div>
      </ion-content>
    </template>
  </Suspense>
</template>
