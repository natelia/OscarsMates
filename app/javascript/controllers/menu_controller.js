import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["nav", "toggle"];

  toggle() {
    this.navTarget.classList.toggle("hidden");
    this.toggleTarget.classList.toggle("open");
  }
}
