import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "button"]

  toggle() {
    const isHidden = this.menuTarget.classList.contains("hidden")
    this.menuTarget.classList.toggle("hidden")
    this.buttonTarget.setAttribute("aria-expanded", isHidden ? "true" : "false")
  }

  close() {
    this.menuTarget.classList.add("hidden")
    this.buttonTarget.setAttribute("aria-expanded", "false")
  }
}
