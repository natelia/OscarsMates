import { Controller } from "@hotwired/stimulus";

// Quick Rating Controller
// Handles star rating hover and click interactions on movie cards
export default class extends Controller {
  static targets = ["star"];
  static values = {
    movieId: Number,
    current: Number,
    hasReview: Boolean,
    reviewId: Number,
  };

  connect() {
    this.updateStars(this.currentValue);
  }

  // Mouse enters a star - highlight all stars up to this one
  starMouseEnter(event) {
    const starValue = parseInt(event.currentTarget.dataset.starValue);
    this.highlightStars(starValue);
  }

  // Mouse leaves the rating area - reset to current value
  starMouseLeave() {
    this.updateStars(this.currentValue);
  }

  // Click a star to submit rating
  async starClick(event) {
    const starValue = parseInt(event.currentTarget.dataset.starValue);

    // Optimistic update
    this.currentValue = starValue;
    this.updateStars(starValue);

    // Add pulse animation
    this.starTargets.forEach((star, index) => {
      if (index < starValue) {
        star.classList.add("star-pulse");
        setTimeout(() => star.classList.remove("star-pulse"), 300);
      }
    });

    // Submit the rating
    try {
      await this.submitRating(starValue);
    } catch (error) {
      console.error("Failed to submit rating:", error);
      // Could show error feedback here
    }
  }

  highlightStars(count) {
    this.starTargets.forEach((star, index) => {
      const isFilled = index < count;
      star.classList.toggle("hovered", isFilled);

      // Update icon
      const icon = star.querySelector("i");
      if (icon) {
        icon.className = isFilled ? "bi bi-star-fill" : "bi bi-star";
      }
    });
  }

  updateStars(count) {
    this.starTargets.forEach((star, index) => {
      const isFilled = index < count;
      star.classList.toggle("filled", isFilled);
      star.classList.remove("hovered");

      // Update icon
      const icon = star.querySelector("i");
      if (icon) {
        icon.className = isFilled ? "bi bi-star-fill" : "bi bi-star";
      }
    });
  }

  async submitRating(stars) {
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
    const year = this.getYearFromUrl();

    // Get movie slug from current page
    const movieCard = this.element.closest(".movie-card");
    const movieId = movieCard.dataset.movieId;

    // We need the movie slug - get it from a link on the card
    const detailsLink = movieCard.querySelector('a[href*="/movies/"]');
    const movieSlug = detailsLink ? detailsLink.href.split("/movies/")[1].split("?")[0] : movieId;

    const url = `/${year}/movies/${movieSlug}/reviews`;

    const formData = new FormData();
    formData.append("review[stars]", stars);
    formData.append("review[watched_on]", new Date().toISOString().split("T")[0]);

    const response = await fetch(url, {
      method: "POST",
      headers: {
        "X-CSRF-Token": csrfToken,
        Accept: "text/vnd.turbo-stream.html, text/html, application/xhtml+xml",
      },
      body: formData,
    });

    if (response.ok) {
      // Update the badge on the card
      this.updateBadge(stars);
      this.hasReviewValue = true;
    }

    return response;
  }

  updateBadge(stars) {
    const movieCard = this.element.closest(".movie-card");
    let badge = movieCard.querySelector(".movie-card-badge");

    if (badge) {
      badge.innerHTML = `${stars} <i class="bi bi-star-fill"></i>`;
    } else {
      // Create badge if it doesn't exist
      badge = document.createElement("div");
      badge.className = "movie-card-badge animate-float";
      badge.innerHTML = `${stars} <i class="bi bi-star-fill"></i>`;
      movieCard.insertBefore(badge, movieCard.firstChild);
    }

    // Add pulse animation
    badge.style.animation = "none";
    badge.offsetHeight; // Trigger reflow
    badge.style.animation = "starPulse 0.3s ease";
  }

  getYearFromUrl() {
    const match = window.location.pathname.match(/\/(\d{4})\//);
    return match ? match[1] : new Date().getFullYear();
  }
}
