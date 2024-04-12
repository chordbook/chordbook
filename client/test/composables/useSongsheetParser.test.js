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

  test('setting capo', async () => {
    parser.capo = 1
    await nextTick()
    expect(parser.capo).toEqual(1)
    expect(parser.key).toEqual('Gm')
    expect(parser.song.metadata.get('_key')).toEqual('Gm')
    expect(parser.song.key).toEqual('F#m')
    expect(parser.song.capo).toEqual('1')
    expect(parser.chords).toEqual(['F#m', 'A', 'D'].map(c => Chord.parse(c)))
    expect(parser.transpose).toEqual(0)
  })

  test('transpose', async () => {
    parser.transpose = 2
    await nextTick()
    expect(parser.transpose).toEqual(2)
    expect(parser.song.key).toEqual('F#m')
    expect(parser.song.metadata.get('_key')).toEqual('Am')
    expect(parser.song.capo).toEqual('3')
    expect(parser.chords.map(c => c.toString())).toEqual(['F#m', 'A', 'D'])
  })

  test('normalizes chords and key', async () => {
    parser = reactive(useSongsheetParser('{key: C}\n{capo: 3}\n[C] [G] [D]'))
    parser.transpose = -1

    await nextTick()
    expect(parser.song.key).toEqual('B')
    expect(parser.chords.map(c => c.toString())).toEqual(['B', 'F#', 'C#'])

    parser.transpose = 2
    await nextTick()
    expect(parser.song.key).toEqual('D')
    expect(parser.chords.map(c => c.toString())).toEqual(['D', 'A', 'E'])

    parser.transpose = 1
    await nextTick()
    expect(parser.song.key).toEqual('C#')
    expect(parser.chords.map(c => c.toString())).toEqual(['C#', 'G#', 'D#'])

    parser.transpose = 0
    await nextTick()
    expect(parser.song.key).toEqual('C')
    expect(parser.chords.map(c => c.toString())).toEqual(['C', 'G', 'D'])
  })
})

describe('modifier', () => {
  test('null modifier does not modify key', async () => {
    const parser = reactive(useSongsheetParser('{key: A#}\n[A#]'))
    parser.modifier = null
    await nextTick()
    expect(parser.key).toEqual('A#')
  })

  test('b modifier', async () => {
    const parser = reactive(useSongsheetParser('{key: A#}\n[A#]', { modifier: 'b' }))
    await nextTick()
    expect(parser.modifier).toEqual('b')
    expect(parser.key).toEqual('Bb')
    expect(parser.chords.map(c => c.toString())).toEqual(['Bb'])
  })

  test('# modifier', async () => {
    const parser = reactive(useSongsheetParser('{key: Db}\n[Db]', { modifier: '#' }))
    await nextTick()
    expect(parser.modifier).toEqual('#')
    expect(parser.key).toEqual('C#')
    expect(parser.chords.map(c => c.toString())).toEqual(['C#'])
  })
})

describe('key', () => {
  test('uses declared key', async () => {
    const parser = reactive(useSongsheetParser('{key: G}\n[Em]'))
    await nextTick()
    expect(parser.key).toEqual('G')
  })

  test('uses preferred modifier', async () => {
    const parser = reactive(useSongsheetParser('{key: G}', { capo: 1, transpose: 1, modifier: 'b' }))
    await nextTick()
    expect(parser.key).toEqual('Ab')
  })

  test('users first chord (for now)', async () => {
    const parser = reactive(useSongsheetParser('[G]'))
    await nextTick()
    expect(parser.key).toEqual('G')
  })

  test('removes modifiers from first chord', async () => {
    const parser = reactive(useSongsheetParser('[Am7]'))
    await nextTick()
    expect(parser.key).toEqual('Am')
  })
})

describe('chords', () => {
  test('gracefully fails with null', async () => {
    const { chords } = useSongsheetParser(null)
    await nextTick()
    expect(chords.value).toEqual([])
  })

  test('returns chords used in the song', () => {
    const { chords } = useSongsheetParser('{title: Hello}\n[C]Hello [G]world [D]!')
    expect(chords.value.map(c => c.toString())).toEqual(['C', 'G', 'D'])
  })
})
