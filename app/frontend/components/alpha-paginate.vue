<template>
  <nav>
    <ol class="flex place-content-center mb-10 gap-2">
      <li
        v-for="letter in letters"
        :key="letter"
      >
        <router-link
          :to="{ query: { letter } }"
          class="uppercase rounded flex place-content-center place-items-center text-xs w-6 h-6 bg-gray-600"
        >
          {{ letter }}
        </router-link>
      </li>
    </ol>
  </nav>
</template>

<script>
export default {
  data () {
    return {
      letters: '#abcdefghijklmnopqrstuvwxyz'.split('')
    }
  }
}
</script>
