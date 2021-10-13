import { Controller } from '@hotwired/stimulus'

// Save forms to localstorage and restore on load
export default class extends Controller {
  connect () {
    this.restore()
  }

  save () {
    localStorage.setItem(this.key, JSON.stringify(Object.fromEntries(this.data)))
  }

  restore () {
    const data = JSON.parse(localStorage.getItem(this.key) || null)

    if (data) {
      Array.from(this.element.elements).forEach(input => {
        if (['radio', 'checkbox'].includes(input.type)) {
          input.checked = input.value === data[input.name]
        } else {
          input.value = data[input.name]
        }
      })
    }
  }

  get data () {
    return new FormData(this.element)
  }

  get key () {
    return this.element.name
  }
}
