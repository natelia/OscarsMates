import { Controller } from "@hotwired/stimulus";
import confetti from 'canvas-confetti';

export default class extends Controller {
  static values = { enabled: Boolean }

  connect() {
    console.log('Confetti controller connected, enabled:', this.enabledValue);
    if (this.enabledValue) {
      this.fireConfetti();
    }
  }

  fireConfetti() {
    console.log('Firing confetti!');
    confetti({
      particleCount: 100,
      spread: 70,
      origin: { y: 0.6 }
    });
  }
} 