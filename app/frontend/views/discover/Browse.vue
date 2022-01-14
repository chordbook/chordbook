<template>
  <div class="grid grid-cols-5 gap-6">
    <div
      v-for="genre in genres"
      :key="genre"
      class="rounded-md relative shadow-lg text-white"
      :style="style(genre.name)"
    >
      <canvas
        class="saturate-0 bg-cover opacity-20 mix-blend-luminosity"
        :style="`background-image: url(${genre.thumbnail})`"
        width="500"
        height="500"
      />
      <div class="absolute inset-0 p-4 flex place-content-center items-end">
        <h2 class="text-xl font-bold text-shadow">
          {{ genre.name }}
        </h2>
      </div>
    </div>
  </div>
</template>

<script>
import { gradient } from '~/lib/gradient'

export default {
  data () {
    return {
      // FIXME: replace with API lookup
      genres: [
        { name: 'Blues', thumbnail: 'https://www.theaudiodb.com/images/media/artist/thumb/qpvwuv1347996168.jpg' },
        { name: 'Classic Rock', thumbnail: 'https://www.theaudiodb.com/images/media/artist/thumb/sqpysw1363808566.jpg' },
        { name: 'Country', thumbnail: 'https://www.theaudiodb.com/images/media/artist/thumb/mayer-john-4fc6a37619f10.jpg' },
        { name: 'Emo', thumbnail: 'https://www.theaudiodb.com/images/media/artist/thumb/5s528r1619605014.jpg' },
        { name: 'Folk', thumbnail: 'https://www.theaudiodb.com/images/media/artist/thumb/rurtyp1364849000.jpg' },
        { name: 'Indie', thumbnail: 'https://www.theaudiodb.com/images/media/artist/thumb/rxqyxx1483806891.jpg' },
        { name: 'Jazz', thumbnail: 'https://www.theaudiodb.com/images/media/artist/thumb/rpppsp1416613437.jpg' },
        { name: 'Pop', thumbnail: 'https://www.theaudiodb.com/images/media/artist/thumb/trxqst1345503618.jpg' },
        { name: 'Pop-Rock', thumbnail: 'https://www.theaudiodb.com/images/media/artist/thumb/suvwup1341874982.jpg' },
        { name: 'Rock', thumbnail: 'https://www.theaudiodb.com/images/media/artist/thumb/rytwxw1363687167.jpg' },
        { name: 'Thrash Metal', thumbnail: 'https://www.theaudiodb.com/images/media/artist/thumb/qxpytq1413317641.jpg' }
      ]
    }
  },

  methods: {
    style (uid) {
      return `background-image: ${gradient(uid, { colors: 4, spin: 22.5 })};`
    }
  }
}
</script>
