import api from '~/api'

const RE = /\{\s*([\w_-]*)\s*:\s*([^}]*)/i

export default class MetadataCompleter {
  constructor () {
    this.matches = {}
  }

  find (params) {
    return api.get('/api/autocomplete.json', { params }).then(response => response.data)
  }

  getCompletions (editor, session, pos, prefix, callback) {
    const line = session.getLine(pos.row).slice(0, pos.col)
    const match = line.match(RE)
    const [, type, query] = match || []

    if (!match || query.length < 3) return callback()

    const startPosition = pos.col - line.indexOf(query)

    this.find({ type, query }).then(results => {
      callback(null, results.map(({ value, meta, data }) => {
        return {
          caption: value,
          value: value.slice(startPosition),
          meta
        }
      }))
    })
  }
}
