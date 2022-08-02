import { useFetch } from '@/client'

const RE = /\{\s*([\w_-]*)\s*:\s*([^}]*)/i

export default class MetadataCompleter {
  find (params) {
    return useFetch('/autocomplete', { params }).get().json()
  }

  getCompletions (editor, session, pos, prefix, callback) {
    const line = session.getLine(pos.row).slice(0, pos.col)
    const match = line.match(RE)
    const [, type, query] = match || []

    if (!match || query.length < 3) return callback()

    const startPosition = pos.col - line.indexOf(query)

    this.find({ type, query }).then(({ data }) => {
      callback(null, data.value.map(({ value, meta }) => {
        return {
          caption: value,
          value: value.slice(startPosition),
          meta
        }
      }))
    })
  }
}
