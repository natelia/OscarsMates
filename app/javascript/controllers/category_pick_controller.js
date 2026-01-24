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
    const isAlreadySelected = movieCard.classList.contains("selected-pick");

    if (isAlreadySelected) {
      // Unselect the movie
      this.unselectMovie(movieCard);
    } else {
      // Select the movie
      this.doSelectMovie(movieCard, movieId);
    }
  }

  doSelectMovie(movieCard, movieId) {
    // Check if this category already has a pick (to know if we should decrement counter)
    const hadPreviousPick = this.movieCardTargets.some((card) =>
      card.classList.contains("selected-pick")
    );

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
      credentials: "same-origin",
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

          // Decrement categories left counter if this was a new pick
          if (!hadPreviousPick) {
            const countElement = document.getElementById("categories-left-count");
            if (countElement) {
              const currentCount = parseInt(countElement.textContent, 10);
              if (currentCount > 0) {
                countElement.textContent = currentCount - 1;
              }
            }
          }
        } else {
          alert("Error: " + (data.errors ? data.errors.join(", ") : "Unknown error"));
        }
      })
      .catch((error) => {
        console.error("Error:", error);
        alert("An error occurred while saving your pick. Please refresh the page and try again.");
      });
  }

  unselectMovie(movieCard) {
    const url = `/${this.yearValue}/user_picks/${this.categoryIdValue}`;

    fetch(url, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('[name="csrf-token"]').content,
      },
      credentials: "same-origin",
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.success) {
          // Remove selection
          movieCard.classList.remove("selected-pick");

          // Update nomination text
          if (this.hasNominationTextTarget) {
            this.nominationTextTarget.textContent = "Pick a movie";
            this.nominationTextTarget.classList.add("text-muted", "italic");
            this.nominationTextTarget.classList.remove("text-secondary", "font-bold");
          }

          // Increment categories left counter
          const countElement = document.getElementById("categories-left-count");
          if (countElement) {
            const currentCount = parseInt(countElement.textContent, 10);
            countElement.textContent = currentCount + 1;
          }
        } else {
          alert("Error: " + (data.errors ? data.errors.join(", ") : "Unknown error"));
        }
      })
      .catch((error) => {
        console.error("Error:", error);
        alert("An error occurred while removing your pick. Please refresh the page and try again.");
      });
  }
}
