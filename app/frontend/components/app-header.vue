<template>
  <header class="py-4 text-white px-4 md:px-6">
    <div class="max-w-8xl mx-auto sticky flex items-center">
      <h1 class="grow">
        <router-link
          to="/"
          class="font-semibold flex items-center"
        >
          <icon-bi:journal-text class="text-green-500 mr-3" />
          <span class="uppercase">Chord Book</span>
        </router-link>
      </h1>

      <ul class="flex gap-8 place-items-center">
        <li>
          <router-link to="/songsheets">
            Songs
          </router-link>
        </li>
        <li>
          <router-link :to="{ name: 'artists' }">
            Artists
          </router-link>
        </li>
        <li>
          <router-link
            to="/songsheets/new"
            class="btn btn-primary btn-small"
          >
            <icon-bi:journal-plus />
            <span class="hidden sm:inline ml-2">Add Song</span>
          </router-link>
        </li>
      </ul>
    </div>
  </header>
</template>
