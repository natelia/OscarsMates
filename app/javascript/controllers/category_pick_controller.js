import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["movieCard", "nominationText"];
  static values = {
    categoryId: Number,
    year: Number,
    pickingAllowed: Boolean,
  };

  connect() {}

  selectMovie(event) {
    if (!this.pickingAllowedValue) {
      alert("Picking is closed after the ceremony date");
      return;
    }

    const movieCard = event.currentTarget;
    const movieId = movieCard.dataset.movieId;

    // Send AJAX request to create/update pick
    const url = `/${this.yearValue}/user_picks`;
    const data = {
      category_id: this.categoryIdValue,
      movie_id: movieId,
      year: this.yearValue,
    };

    fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('[name="csrf-token"]').content,
      },
      body: JSON.stringify(data),
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.success) {
          // Update UI
          this.movieCardTargets.forEach((card) => {
            card.classList.remove("selected-pick");
          });
          movieCard.classList.add("selected-pick");

          // Update nomination text
          if (this.hasNominationTextTarget) {
            this.nominationTextTarget.textContent = data.movie_title;
            this.nominationTextTarget.classList.remove("text-muted", "italic");
            this.nominationTextTarget.classList.add("text-secondary", "font-bold");
          }
        } else {
          alert("Error: " + data.errors.join(", "));
        }
      })
      .catch((error) => {
        console.error("Error:", error);
        alert("An error occurred while saving your pick");
      });
  }
}
