import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    page: Number,
    url: String,
  };

  connect() {
    this.observer = new IntersectionObserver((entries) => this.handleIntersection(entries), {
      threshold: 0.1,
      rootMargin: "100px",
    });

    this.observer.observe(this.element);
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect();
    }
  }

  handleIntersection(entries) {
    entries.forEach((entry) => {
      if (entry.isIntersecting && !this.loading) {
        this.loadMore();
      }
    });
  }

  async loadMore() {
    if (this.loading) return;

    this.loading = true;

    try {
      const response = await fetch(this.urlValue, {
        headers: {
          Accept: "text/vnd.turbo-stream.html",
        },
      });

      if (response.ok) {
        const html = await response.text();

        // Remove the old trigger
        this.element.remove();

        // Process the turbo stream response
        Turbo.renderStreamMessage(html);
      }
    } catch (error) {
      console.error("Error loading more reviews:", error);
    } finally {
      this.loading = false;
    }
  }
}
