<template>
  <header class="bg-black w-64 overflow-auto">
    <h1 class="text-blue-500 font-semibold text-base p-4 md:px-6 lg:px-8 border-b border-blue-900/75">
      <router-link
        to="/"
        class="flex items-center"
      >
        <icon-bi:journal-text class="icon-small mr-4" />
        <span class="uppercase">Chord Book</span>
      </router-link>
    </h1>

    <div class="flex flex-col gap-10 p-4 md:p-6 lg:p-8 font-sm font-semibold text-blue-100">
      <ul class="flex flex-col gap-4">
        <li>
          <router-link :to="{ name: 'discover' }">
            <icon-bi:search class="text-blue-500 icon-small mr-4" />
            Discover
          </router-link>
        </li>
      </ul>

      <ul class="flex flex-col gap-4">
        <li class="text-xs tracking-wide font-light uppercase text-blue-200/90">
          Library
        </li>
        <li>
          <router-link to="/songsheets">
            <icon-bi:music-note class="text-blue-500 icon-small mr-4" />
            Songs
          </router-link>
        </li>
        <li>
          <router-link :to="{ name: 'artists' }">
            <icon-bi:person-fill class="text-blue-500 icon-small mr-4" />
            Artists
          </router-link>
        </li>
      </ul>

      <ul class="flex flex-col gap-4">
        <li class="text-xs tracking-wide font-light uppercase text-blue-300/90">
          Setlists
        </li>
        <li>
          <a
            href="#"
            class=""
          >
            <icon-bi:plus class="text-blue-500 icon-small mr-4" />

            Create Setlist
          </a>
        </li>
      </ul>

      <ul class="flex flex-col gap-4">
        <li class="text-xs tracking-wide font-light uppercase text-blue-300/90">
          Tools
        </li>
        <li>
          <router-link :to="{ name: 'tuner' }">
            <icon-bi:mic-fill class="text-blue-500 icon-small mr-4" />
            Tuner
          </router-link>
        </li>
        <li>
          <router-link :to="{ name: 'tuner' }">
            <icon-app-chord-diagram class="text-blue-500 icon-small mr-4" />
            Chords
          </router-link>
        </li>
      </ul>
    </div>
  </header>
</template>
