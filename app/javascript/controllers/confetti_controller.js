import { Controller } from "@hotwired/stimulus";
import confetti from "canvas-confetti";

export default class extends Controller {
  static values = { enabled: Boolean };

  connect() {
    if (this.enabledValue) {
      this.fireConfetti();
    }
  }

  fireConfetti() {
    confetti({
      particleCount: 100,
      spread: 70,
      origin: { y: 0.6 },
    });
  }
}
