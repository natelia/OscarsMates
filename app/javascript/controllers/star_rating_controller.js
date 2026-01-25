import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["star"]

  connect() {
    this.updateSelected()
  }

  hover(event) {
    const hoveredValue = parseInt(event.currentTarget.dataset.value)
    this.starTargets.forEach(star => {
      const value = parseInt(star.dataset.value)
      star.classList.toggle("hovered", value <= hoveredValue)
    })
  }

  leave() {
    this.starTargets.forEach(star => star.classList.remove("hovered"))
  }

  updateSelected() {
    const checked = this.element.querySelector("input:checked")
    const selectedValue = checked ? parseInt(checked.value) : 0
    this.starTargets.forEach(star => {
      const value = parseInt(star.dataset.value)
      star.classList.toggle("selected", value <= selectedValue)
    })
  }

  select(_event) {
    // Radio button handles the actual selection, just update visuals
    setTimeout(() => this.updateSelected(), 0)
  }
}
