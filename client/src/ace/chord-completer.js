const RE = /\[([A-G][#b]?.*?)\]/gi

export default class ChordCompleter {
  find (text) {
    return [...text.matchAll(RE)].reduce((chords, [_, chord]) => {
      chords[chord] = chords[chord] + 1 || 1
      return chords
    }, {})
  }

  getCompletions (editor, session, pos, prefix, callback) {
    const chords = this.find(editor.getValue())

    callback(null, Object.entries(chords).map(([name, score]) => {
      return {
        name,
        value: `[${name}]`,
        score,
        meta: 'chord'
      }
    }))
  }
}
