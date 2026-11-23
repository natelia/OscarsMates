import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["message", "submit", "count"];

  connect() {
    this.checkLength();
  }

  checkLength() {
    const length = this.messageTarget.value.length;
    this.countTarget.textContent = length;

    if (length >= 100) {
      this.submitTarget.disabled = false;
      this.submitTarget.classList.remove("opacity-50", "cursor-not-allowed");
    } else {
      this.submitTarget.disabled = true;
      this.submitTarget.classList.add("opacity-50", "cursor-not-allowed");
    }
  }
}
