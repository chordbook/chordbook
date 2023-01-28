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
            class="scale-[2]"
            duration="1200"
          />
        </div>
      </ion-content>
    </template>
  </Suspense>
</template>
