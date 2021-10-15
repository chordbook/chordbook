import { Controller } from '@hotwired/stimulus'
import nosleep from 'nosleep.js'
import NoSleep from 'nosleep.js'

const noSleep = new NoSleep()
window.noSleep = noSleep

export default class extends Controller {
  static targets = ['toggle']

  connect () {
    this.toggleTargets.forEach(input => { input.checked = noSleep.enabled })
  }

  // Enable must be wrapped in a user input event handler (e.g. a mouse or touch handler)
  enable () {
    noSleep.enable()
  }

  disable () {
    noSleep.disable()
  }

  toggle () {
    noSleep.isEnabled ? this.disable() : this.enable()
  }
}
