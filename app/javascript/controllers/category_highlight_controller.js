import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.boundHighlight = this.highlightCategory.bind(this);
    this.highlightCategory();

    // Also handle hash changes (e.g., clicking another category link)
    window.addEventListener("hashchange", this.boundHighlight);
  }

  disconnect() {
    if (this.boundHighlight) {
      window.removeEventListener("hashchange", this.boundHighlight);
    }
  }

  highlightCategory() {
    // Check if there's a hash in the URL
    const hash = window.location.hash;
    if (hash && hash.startsWith("#category-")) {
      // Wait for the scroll to complete
      setTimeout(() => {
        const targetElement = document.querySelector(hash);
        if (targetElement) {
          // Remove any existing highlight first
          document.querySelectorAll(".category-highlight").forEach((el) => {
            el.classList.remove("category-highlight");
          });

          // Add highlight class
          targetElement.classList.add("category-highlight");

          // Remove highlight class after animation completes (1s)
          setTimeout(() => {
            targetElement.classList.remove("category-highlight");
          }, 1000);
        }
      }, 300);
    }
  }
}
