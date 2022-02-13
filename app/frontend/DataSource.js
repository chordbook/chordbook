import client from '@/client'
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

    const response = await client.get(this.url, this.options)
    this.items.push(...response.data)

    this.loading = false

    if (response.headers.link) {
      const links = LinkHeader.parse(response.headers.link)

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
