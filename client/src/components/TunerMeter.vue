<script setup>
defineProps({
  cents: {
    type: [Number, null],
    required: true
  }
})

const range = 90

function centsToDegrees (cents) {
  return cents * (range / 100) + 'deg'
}
</script>

<template>
  <div class="meter absolute inset-1">
    <div
      v-for="index in 11"
      :key="index"
      :class="{
        'absolute left-1/2 -translate-x-1/2 h-full origin-center rounded opacity-50 w-[1px] border-current border-t-[10px]': true,
        'w-[3px] border-t-[20px]': (index - 1) % 5 === 0
      }"
      :style="{ '--tw-rotate': centsToDegrees((index - 6) * 10) }"
    >
      <span
        v-if="index == 1"
        class="absolute right-2 -top-5"
      >♭</span>
      <span
        v-if="index == 11"
        class="absolute left-2 -top-5"
      >♯</span>
    </div>
    <div
      v-if="cents"
      class="absolute left-1/2 -translate-x-1/2 h-full origin-center transition-transform duration-100"
      :style="{ '--tw-rotate': centsToDegrees(cents || 0) }"
    >
      <div
        v-if="cents"
        :class="{
          'rounded-md w-0 h-0 transition-all duration-200': true,
          'h-[20px] border-x-[6px] rounded border-green-500': Math.abs(cents) <= 5,
          // Make it a CSS arrow if off by more than 5 cents
          'border-[10.5px] mt-[-1px] border-t-transparent border-b-transparent': Math.abs(cents) > 5,
          'border-r-0': cents < 5, // Right arrow
          'border-l-0': cents > 5, // Left arrow
          'border-yellow-500': Math.abs(cents) > 5 && Math.abs(cents) <= 25,
          'border-red-500': Math.abs(cents) > 25,
        }"
      />
    </div>
  </div>
</template>
