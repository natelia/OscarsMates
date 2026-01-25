import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["star", "input"]

  connect() {
    this.updateDisplay()
  }

  hover(event) {
    const value = parseInt(event.currentTarget.dataset.value)
    this.highlightUpTo(value)
  }

  leave() {
    this.updateDisplay()
  }

  select(event) {
    const value = parseInt(event.currentTarget.dataset.value)
    const input = this.element.querySelector(`input[value="${value}"]`)
    if (input) {
      input.checked = true
    }
    this.updateDisplay()
  }

  highlightUpTo(value) {
    this.starTargets.forEach(star => {
      const starValue = parseInt(star.dataset.value)
      star.classList.toggle("highlighted", starValue <= value)
    })
  }

  updateDisplay() {
    const checked = this.element.querySelector("input:checked")
    const selectedValue = checked ? parseInt(checked.value) : 0

    this.starTargets.forEach(star => {
      const starValue = parseInt(star.dataset.value)
      star.classList.toggle("selected", starValue <= selectedValue)
      star.classList.remove("highlighted")
    })
  }
}
