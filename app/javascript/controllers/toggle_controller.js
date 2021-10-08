import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['input']

  connect() {
    this.inputTargets.forEach(input => { this.changed(input) })
  }

  visibility(e) {
    this.apply(el => el.hidden = !e.target.checked)
  }

  classes(e) {
    let classesToAdd = []
    let classesToRemove = []

    this.inputTargets.forEach(input => {
      if(input.dataset.toggleClasses) {
        (input.checked ? classesToAdd : classesToRemove).push(...input.dataset.toggleClasses.split(" "))
      }
    })

    this.apply(el => {
      el.classList.add(...classesToAdd)
      el.classList.remove(...classesToRemove)
    })
  }

  changed(input) {
    input.dispatchEvent(new CustomEvent('input'))
  }

  apply(fn) {
    this.targetElements.forEach(fn)
  }

  get name() {
    return this.element.name
  }

  get checked() {
    return !!this.element.checked
  }

  get targetElements() {
    return document.querySelectorAll(this.element.dataset.target)
  }
}
