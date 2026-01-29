import { Controller } from "@hotwired/stimulus";

// Star Rating Controller for Review Form
// Handles interactive star selection with hover preview
export default class extends Controller {
  static targets = ["star", "radio"];

  connect() {
    // Track the last selected value to detect clicks on the same star
    this.lastSelectedValue = null;

    // Only update stars if there's a pre-existing selection
    const selectedRadio = this.radioTargets.find((r) => r.checked);
    if (selectedRadio) {
      this.lastSelectedValue = parseInt(selectedRadio.value);
      this.updateStars();
    }
    this.updateButtonText();
    this.updateRatingDisplay();
  }

  // Get the submit button from the form
  get submitButton() {
    const form = this.element.closest("form");
    return form
      ? form.querySelector('input[type="submit"]') || form.querySelector('button[type="submit"]')
      : null;
  }

  // Get the rating display element
  get ratingDisplay() {
    return this.element.querySelector('[data-star-rating-target="ratingDisplay"]');
  }

  // Mouse enters a star - highlight all stars up to this one
  starMouseEnter(event) {
    const starValue = parseInt(event.currentTarget.dataset.starValue);
    this.highlightStars(starValue);
  }

  // Mouse leaves the rating area - reset to current value
  starMouseLeave() {
    this.updateStars();
  }

  // Click a star to select rating (or unselect if already selected)
  starClick(event) {
    event.preventDefault();
    event.stopPropagation();
    const starValue = parseInt(event.currentTarget.dataset.starValue);
    const radio = this.radioTargets.find((r) => parseInt(r.value) === starValue);
    if (radio) {
      // If clicking on already selected star, uncheck it
      if (this.lastSelectedValue === starValue) {
        this.lastSelectedValue = null;
        this.radioTargets.forEach((r) => (r.checked = false));
      } else {
        // Uncheck all other radios first
        this.lastSelectedValue = starValue;
        this.radioTargets.forEach((r) => (r.checked = false));
        radio.checked = true;
      }
      this.updateStars();
      this.updateButtonText();
      this.updateRatingDisplay();
    }
  }

  // Update button text and disabled state based on whether rating is selected
  updateButtonText() {
    const submitButton = this.submitButton;
    if (!submitButton) return;

    const selectedRadio = this.radioTargets.find((r) => r.checked);
    const isEdit = submitButton.dataset.isEdit === "true";

    if (isEdit) {
      if (selectedRadio) {
        submitButton.value = "Update";
      } else {
        submitButton.value = "Remove rating";
      }
      // Enable button for edit mode (can save with or without rating)
      submitButton.disabled = false;
    } else {
      // New review mode: disable button if no rating selected
      if (selectedRadio) {
        submitButton.value = "Mark as Watched";
        submitButton.disabled = false;
      } else {
        submitButton.value = "Mark as Watched";
        submitButton.disabled = true;
      }
    }
  }

  // Update rating display in the title
  updateRatingDisplay() {
    const ratingDisplay = this.ratingDisplay;
    if (!ratingDisplay) return;

    const selectedRadio = this.radioTargets.find((r) => r.checked);
    if (selectedRadio) {
      ratingDisplay.textContent = `${selectedRadio.value}/10`;
      ratingDisplay.classList.remove("hidden");
    } else {
      ratingDisplay.textContent = "";
      ratingDisplay.classList.add("hidden");
    }
  }

  // Highlight stars for hover preview
  highlightStars(count) {
    this.starTargets.forEach((star, index) => {
      const starValue = parseInt(star.dataset.starValue);
      const svg = star.querySelector("svg");
      if (svg) {
        if (starValue <= count) {
          svg.classList.remove("star-unfilled");
          svg.classList.add("star-hovered");
        } else {
          svg.classList.remove("star-hovered");
          svg.classList.add("star-unfilled");
        }
      }
    });
  }

  // Update stars to show selected rating
  updateStars() {
    const selectedRadio = this.radioTargets.find((r) => r.checked);
    const selectedValue = selectedRadio ? parseInt(selectedRadio.value) : 0;

    this.starTargets.forEach((star) => {
      const starValue = parseInt(star.dataset.starValue);
      const svg = star.querySelector("svg");
      if (svg) {
        svg.classList.remove("star-hovered");
        if (starValue <= selectedValue) {
          svg.classList.remove("star-unfilled");
          svg.classList.add("star-filled");
        } else {
          svg.classList.remove("star-filled");
          svg.classList.add("star-unfilled");
        }
      }
    });
  }
}
