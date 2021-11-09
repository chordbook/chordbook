<template>
  <header class="py-4 text-white">
    <div class="container sticky flex items-center">
      <h1 class="flex-grow">
        <a
          href="/"
          class="font-semibold flex items-center"
        >
          <icon-bi:journal-text class="text-green-500 mr-3" />
          <span class="uppercase">Chord Book</span>
        </a>
      </h1>

      <div>
        <a
          href="/songsheets/new"
          class="btn btn-primary btn-small"
        >
          <icon-bi:journal-plus />
          <span class="hidden sm:inline ml-2">Add Song</span>
        </a>
      </div>
    </div>
  </header>
</template>

<script>
export default {
}
</script>
