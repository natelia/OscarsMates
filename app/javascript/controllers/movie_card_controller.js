import { Controller } from "@hotwired/stimulus";

// Movie Card Controller
// Handles card interactions including mobile touch support
export default class extends Controller {
  static values = {
    movieId: String,
  };

  connect() {
    this.isTouchDevice = "ontouchstart" in window;
    this.isExpanded = false;
    this.isReviewed = this.element.dataset.reviewed === "true";

    if (this.isTouchDevice) {
      this.setupTouchInteractions();
    }
  }

  disconnect() {
    if (this.isTouchDevice) {
      document.removeEventListener("click", this.handleOutsideClick);
    }
  }

  setupTouchInteractions() {
    // On touch devices, first tap expands, second tap follows link
    this.element.addEventListener("click", this.handleTouchClick.bind(this));

    // Close when tapping outside
    this.handleOutsideClick = (event) => {
      if (!this.element.contains(event.target) && this.isExpanded) {
        this.collapse();
      }
    };
    document.addEventListener("click", this.handleOutsideClick);
  }

  handleTouchClick(event) {
    const overlay = this.element.querySelector(".movie-card-overlay");
    const actions = this.element.querySelector(".movie-card-actions");

    if (!overlay || !actions) return;

    // If clicking on an actual link or button, let it through
    if (
      event.target.closest("a") ||
      event.target.closest("button") ||
      event.target.closest("form")
    ) {
      return;
    }

    if (!this.isExpanded) {
      event.preventDefault();
      this.expand();
    }
  }

  expand() {
    this.isExpanded = true;
    this.element.classList.add("is-expanded");

    const overlay = this.element.querySelector(".movie-card-overlay");
    const actions = this.element.querySelector(".movie-card-actions");

    if (overlay) {
      overlay.style.opacity = "1";
    }
    if (actions) {
      actions.style.opacity = "1";
      actions.style.transform = "translateY(0)";
    }
  }

  collapse() {
    this.isExpanded = false;
    this.element.classList.remove("is-expanded");

    const overlay = this.element.querySelector(".movie-card-overlay");
    const actions = this.element.querySelector(".movie-card-actions");

    if (overlay) {
      overlay.style.opacity = "";
    }
    if (actions) {
      actions.style.opacity = "";
      actions.style.transform = "";
    }
  }
}
