import { useSongsheetParser } from '@/composables'
import { Chord } from 'chordsheetjs'
import { describe, expect, test, beforeEach } from 'vitest'
import { reactive, nextTick } from 'vue'

describe('transposing', () => {
  let parser = null

  beforeEach(() => {
    parser = reactive(useSongsheetParser('{key: Em}\n{capo: 3}\n[Em] [G] [C]'))
  })

  test('defaults', async () => {
    expect(parser.song.metadata.get('_key')).toEqual('Gm')
    expect(parser.song.key).toEqual('Em')
    expect(parser.song.capo).toEqual('3')
    expect(parser.chords).toEqual(['Em', 'G', 'C'].map(c => Chord.parse(c)))
    expect(parser.capo).toEqual(3)
    expect(parser.transpose).toEqual(0)
  })

  test('setting capo', () => {
    parser.capo = 1
    expect(parser.song.metadata.get('_key')).toEqual('Gm')
    expect(parser.song.key).toEqual('F#m')
    expect(parser.song.capo).toEqual('1')
    expect(parser.chords).toEqual(['F#m', 'A', 'D'].map(c => Chord.parse(c)))
    expect(parser.capo).toEqual(1)
    expect(parser.transpose).toEqual(0)
  })

  test('transpose', async () => {
    parser.transpose = 2

    // Wait for watchers to do their thing
    await nextTick()

    expect(parser.transpose).toEqual(2)
    expect(parser.song.key).toEqual('F#m')
    expect(parser.song.metadata.get('_key')).toEqual('Am')
    expect(parser.song.capo).toEqual('3')
    expect(parser.chords.map(c => c.toString())).toEqual(['F#m', 'A', 'D'])
  })
})
