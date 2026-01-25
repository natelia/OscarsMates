import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "nav"]

  connect() {
    this.isOpen = false
  }

  toggle() {
    this.isOpen = !this.isOpen
    this.buttonTarget.setAttribute("aria-expanded", this.isOpen)

    if (this.isOpen) {
      this.navTarget.classList.remove("hidden")
    } else {
      this.navTarget.classList.add("hidden")
    }
  }

  // Close menu when clicking outside
  closeOnClickOutside(event) {
    if (this.isOpen && !this.element.contains(event.target)) {
      this.isOpen = false
      this.buttonTarget.setAttribute("aria-expanded", "false")
      this.navTarget.classList.add("hidden")
    }
  }

  // Close menu on escape key
  closeOnEscape(event) {
    if (event.key === "Escape" && this.isOpen) {
      this.isOpen = false
      this.buttonTarget.setAttribute("aria-expanded", "false")
      this.navTarget.classList.add("hidden")
      this.buttonTarget.focus()
    }
  }
}
