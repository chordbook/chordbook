<template>
  <nav>
    <ol class="flex place-content-center mb-10 gap-1">
      <li
        v-for="letter in letters"
        :key="letter"
      >
        <router-link
          :to="{ query: { letter } }"
          :class="{
            'text-white bg-slate-500': letter === selected,
            'text-slate-400 bg-slate-200 hover:bg-slate-300 dark:bg-slate-600': letter !== selected,
            'uppercase rounded flex place-content-center place-items-center text-xs w-5 h-5': true
          }"
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
  },

  computed: {
    selected () {
      return this.$route.query.letter
    }
  }
}
</script>
