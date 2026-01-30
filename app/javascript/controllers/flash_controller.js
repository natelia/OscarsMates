import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    autoDismiss: Boolean,
  };

  connect() {
    // Add entrance animation
    this.element.style.opacity = "0";
    this.element.style.transform = "translateX(-100%)";

    // Trigger animation on next frame
    requestAnimationFrame(() => {
      this.element.style.opacity = "1";
      this.element.style.transform = "translateX(0)";
    });

    // Set up auto-dismiss if enabled
    if (this.autoDismissValue) {
      this.autoDismissTimer = setTimeout(() => {
        this.dismiss();
      }, 3000);
    }
  }

  disconnect() {
    // Clear timer if component is removed
    if (this.autoDismissTimer) {
      clearTimeout(this.autoDismissTimer);
    }
  }

  dismiss() {
    // Clear auto-dismiss timer if it exists
    if (this.autoDismissTimer) {
      clearTimeout(this.autoDismissTimer);
    }

    // Exit animation
    this.element.style.opacity = "0";
    this.element.style.transform = "translateY(8px)";

    // Remove element after animation completes
    setTimeout(() => {
      this.element.remove();
    }, 200);
  }
}
