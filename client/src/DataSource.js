import { useFetch } from '@/client'
import LinkHeader from 'http-link-header'

export default class DataSource {
  constructor (url, options = {}) {
    this.url = url
    this.options = options
    this.loading = false
    this.disabled = false
    this.items = []
  }

  async load () {
    if (this.disabled || this.loading) return
    this.loading = true

    const { data, response } = await useFetch(this.url, { params: this.options }).get().json()
    this.items.push(...data.value)

    this.loading = false

    const linkHeader = response.value.headers.get('Link')

    if (linkHeader) {
      const links = LinkHeader.parse(linkHeader)

      if (links.has('rel', 'next')) {
        this.url = links.get('rel', 'next')[0].uri
      } else {
        this.disabled = true
      }
    } else {
      this.disabled = true
    }
  }
}
