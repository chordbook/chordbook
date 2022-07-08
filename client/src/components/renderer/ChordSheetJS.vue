<script setup>
import ChordLyricsPair from '@/components/ChordLyricsPair.vue'
import SongSheetComment from '@/components/SongSheetComment.vue'

defineProps({
  song: {
    type: Object,
    required: true
  }
})

function componentFor (item) {
  return [ChordLyricsPair, SongSheetComment].find(c => c.for(item))
}

</script>

<template>
  <div class="chord-sheet mt-2">
    <div
      v-if="song.capo"
      class="capo my-4"
    >
      Capo {{ song.capo }}
    </div>
    <div
      v-if="song.subtitle"
      class="my-1"
    >
      {{ song.subtitle }}
    </div>

    <div
      v-for="{ type, lines } in song.paragraphs"
      :key="type + JSON.stringify(lines)"
      :class="type + ' paragraph'"
    >
      <template
        v-for="line in lines"
        :key="JSON.stringify(line)"
      >
        <div
          v-if="line.hasRenderableItems()"
          class="row"
        >
          <template
            v-for="item in line.items"
            :key="JSON.stringify(item)"
          >
            <component
              :is="componentFor(item)"
              v-if="item.isRenderable()"
              :item="item"
            />
          </template>
        </div>
      </template>
    </div>
  </div>
</template>
