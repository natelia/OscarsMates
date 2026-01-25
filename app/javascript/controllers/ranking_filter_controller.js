import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "searchInput",
    "userName",
    "rankingList",
    "rankingItem",
    "progressFill",
    "progressBar",
  ];

  connect() {
    this.alignProgressBars();
  }

  alignProgressBars() {
    if (!this.hasUserNameTarget) return;

    let maxWidth = 0;
    this.userNameTargets.forEach((el) => {
      const width = el.offsetWidth;
      if (width > maxWidth) {
        maxWidth = width;
      }
    });

    const identityWidth = maxWidth + 120;
    this.element.style.setProperty("--identity-width", `${identityWidth}px`);
  }

  setMetric(event) {
    event.preventDefault();
    const metric = event.currentTarget.dataset.metric;
    this.animateFilterChange({ metric });
  }

  setMode(event) {
    event.preventDefault();
    const mode = event.currentTarget.dataset.mode;
    this.animateFilterChange({ mode });
  }

  setScope(event) {
    event.preventDefault();
    const scope = event.currentTarget.dataset.scope;
    this.animateFilterChange({ scope });
  }

  submitSearch(event) {
    event.preventDefault();
    const query = this.searchInputTarget.value;
    this.navigateWithParams({ query });
  }

  search(event) {
    clearTimeout(this.searchTimeout);
    this.searchTimeout = setTimeout(() => {
      const query = event.target.value;
      this.navigateWithParams({ query });
    }, 400);
  }

  clearSearch(event) {
    event.preventDefault();
    if (this.hasSearchInputTarget) {
      this.searchInputTarget.value = "";
    }
    this.navigateWithParams({ query: null });
  }

  // Animate filter changes with FLIP animation
  async animateFilterChange(newParams) {
    if (!this.hasRankingListTarget) {
      this.navigateWithParams(newParams);
      return;
    }

    // Update active filter UI immediately
    this.updateActiveFilters(newParams);

    // FIRST: Record current positions of existing items
    const firstPositions = new Map();
    this.rankingItemTargets.forEach((item) => {
      const userId = item.dataset.userId;
      const rect = item.getBoundingClientRect();
      firstPositions.set(userId, { top: rect.top, left: rect.left, el: item });
    });

    // Fetch new content
    const url = this.buildUrl(newParams);

    try {
      const response = await fetch(url, {
        headers: {
          Accept: "text/html",
          "X-Requested-With": "XMLHttpRequest",
        },
      });

      if (!response.ok) {
        this.navigateWithParams(newParams);
        return;
      }

      const html = await response.text();
      const parser = new DOMParser();
      const doc = parser.parseFromString(html, "text/html");
      const newList = doc.querySelector('[data-ranking-filter-target="rankingList"]');

      if (!newList) {
        this.navigateWithParams(newParams);
        return;
      }

      // Get new items and their order
      const newItems = Array.from(
        newList.querySelectorAll('[data-ranking-filter-target="rankingItem"]')
      );
      const newUserIds = new Set(newItems.map((item) => item.dataset.userId));
      const existingUserIds = new Set(this.rankingItemTargets.map((item) => item.dataset.userId));

      // Create a map of new item data
      const newItemsData = new Map();
      newItems.forEach((item) => {
        newItemsData.set(item.dataset.userId, item);
      });

      const listEl = this.rankingListTarget;

      // 1. Remove items that are no longer in the new list (with fade out)
      const itemsToRemove = this.rankingItemTargets.filter(
        (item) => !newUserIds.has(item.dataset.userId)
      );
      itemsToRemove.forEach((item) => {
        item.style.transition = "opacity 0.3s ease, transform 0.3s ease";
        item.style.opacity = "0";
        item.style.transform = "scale(0.95)";
      });

      // Wait for fade out
      if (itemsToRemove.length > 0) {
        await new Promise((resolve) => setTimeout(resolve, 300));
        itemsToRemove.forEach((item) => item.remove());
      }

      // 2. Update existing items that are in both lists
      newItems.forEach((newItemData) => {
        const userId = newItemData.dataset.userId;
        const existingItem = this.rankingItemTargets.find((item) => item.dataset.userId === userId);

        if (existingItem) {
          // Update rank number
          const oldRank = existingItem.querySelector(".ranking-number");
          const newRank = newItemData.querySelector(".ranking-number");
          if (oldRank && newRank) {
            oldRank.textContent = newRank.textContent;
          }

          // Update progress bars with animation
          this.updateProgressBars(existingItem, newItemData);

          // Update bar styles (main vs secondary)
          this.updateBarStyles(existingItem, newItemData);
        }
      });

      // 3. Add new items that weren't in the old list (hidden initially)
      const itemsToAdd = [];
      newItems.forEach((newItemData) => {
        const userId = newItemData.dataset.userId;
        if (!existingUserIds.has(userId)) {
          const newItem = newItemData.cloneNode(true);
          newItem.style.opacity = "0";
          newItem.style.transform = "scale(0.95)";
          itemsToAdd.push({ userId, element: newItem });
        }
      });

      // Re-read positions after removals
      const currentItems = Array.from(
        listEl.querySelectorAll('[data-ranking-filter-target="rankingItem"]')
      );
      const midPositions = new Map();
      currentItems.forEach((item) => {
        const rect = item.getBoundingClientRect();
        midPositions.set(item.dataset.userId, { top: rect.top, left: rect.left });
      });

      // 4. Reorder DOM elements according to new order and insert new items
      newItems.forEach((newItemData) => {
        const userId = newItemData.dataset.userId;
        const existingItem = listEl.querySelector(`[data-user-id="${userId}"]`);

        if (existingItem) {
          listEl.appendChild(existingItem);
        } else {
          // Find the new item to add
          const itemToAdd = itemsToAdd.find((i) => i.userId === userId);
          if (itemToAdd) {
            listEl.appendChild(itemToAdd.element);
          }
        }
      });

      // LAST: Get final positions
      const finalItems = Array.from(
        listEl.querySelectorAll('[data-ranking-filter-target="rankingItem"]')
      );
      const lastPositions = new Map();
      finalItems.forEach((item) => {
        const rect = item.getBoundingClientRect();
        lastPositions.set(item.dataset.userId, { top: rect.top, left: rect.left });
      });

      // INVERT & PLAY: Animate existing items from old position to new
      const animations = [];
      finalItems.forEach((item) => {
        const userId = item.dataset.userId;
        const first = firstPositions.get(userId);
        const last = lastPositions.get(userId);

        if (first && last) {
          const deltaY = first.top - last.top;

          if (Math.abs(deltaY) > 1) {
            item.style.transform = `translateY(${deltaY}px)`;
            item.style.transition = "none";

            // Force reflow
            item.offsetHeight;

            item.style.transition = "transform 0.5s cubic-bezier(0.4, 0, 0.2, 1)";
            item.style.transform = "";

            animations.push(
              new Promise((resolve) => {
                const handler = () => {
                  item.removeEventListener("transitionend", handler);
                  resolve();
                };
                item.addEventListener("transitionend", handler);
                setTimeout(resolve, 600);
              })
            );
          }
        }
      });

      // Fade in new items
      itemsToAdd.forEach(({ element }) => {
        element.offsetHeight; // Force reflow
        element.style.transition = "opacity 0.4s ease, transform 0.4s ease";
        element.style.opacity = "1";
        element.style.transform = "scale(1)";
      });

      // Update URL without reload
      window.history.pushState({}, "", url);

      await Promise.all(animations);

      // Clean up styles
      finalItems.forEach((item) => {
        item.style.transform = "";
        item.style.transition = "";
        item.style.opacity = "";
      });

      // Re-initialize lucide icons for new items
      if (window.lucide) {
        window.lucide.createIcons();
      }

      // Re-align progress bars
      this.alignProgressBars();
    } catch (error) {
      console.error("Animation failed, falling back to navigation:", error);
      this.navigateWithParams(newParams);
    }
  }

  updateProgressBars(existingItem, newItemData) {
    const existingFills = existingItem.querySelectorAll(
      '[data-ranking-filter-target="progressFill"]'
    );
    const newFills = newItemData.querySelectorAll('[data-ranking-filter-target="progressFill"]');

    // Store new values but don't apply yet
    const updates = [];
    existingFills.forEach((fill, index) => {
      const newFill = newFills[index];
      if (newFill) {
        const newPercentage = newFill.dataset.percentage;
        updates.push({ fill, newPercentage });
      }
    });

    // Update stats text immediately
    const existingStats = existingItem.querySelectorAll(
      '[data-ranking-filter-target="progressStats"]'
    );
    const newStats = newItemData.querySelectorAll('[data-ranking-filter-target="progressStats"]');
    existingStats.forEach((stat, index) => {
      const newStat = newStats[index];
      if (newStat) {
        stat.textContent = newStat.textContent;
      }
    });

    // Update percentage text immediately
    const existingPercents = existingItem.querySelectorAll(
      '[data-ranking-filter-target="progressPercent"]'
    );
    const newPercents = newItemData.querySelectorAll(
      '[data-ranking-filter-target="progressPercent"]'
    );
    existingPercents.forEach((pct, index) => {
      const newPct = newPercents[index];
      if (newPct) {
        pct.textContent = newPct.textContent;
      }
    });

    // Apply width changes with a small delay to ensure transition triggers
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        updates.forEach(({ fill, newPercentage }) => {
          fill.style.transition = "width 0.5s cubic-bezier(0.4, 0, 0.2, 1)";
          fill.style.width = `${newPercentage}%`;
          fill.dataset.percentage = newPercentage;
        });
      });
    });
  }

  updateBarStyles(existingItem, newItemData) {
    const existingBars = existingItem.querySelectorAll(
      '[data-ranking-filter-target="progressBar"]'
    );
    const newBars = newItemData.querySelectorAll('[data-ranking-filter-target="progressBar"]');

    existingBars.forEach((bar, index) => {
      const newBar = newBars[index];
      if (newBar) {
        bar.className = newBar.className;
      }
    });
  }

  updateActiveFilters(params) {
    // Update metric filters
    if (params.metric) {
      document.querySelectorAll("[data-metric]").forEach((el) => {
        el.classList.toggle("active", el.dataset.metric === params.metric);
      });
    }

    // Update mode filters
    if (params.mode) {
      document.querySelectorAll("[data-mode]").forEach((el) => {
        el.classList.toggle("active", el.dataset.mode === params.mode);
      });
    }

    // Update scope filters
    if (params.scope) {
      document.querySelectorAll("[data-scope]").forEach((el) => {
        el.classList.toggle("active", el.dataset.scope === params.scope);
      });
    }
  }

  buildUrl(newParams) {
    const url = new URL(window.location.href);

    Object.entries(newParams).forEach(([key, value]) => {
      if (value === null || value === "" || value === undefined) {
        url.searchParams.delete(key);
      } else {
        url.searchParams.set(key, value);
      }
    });

    return url.toString();
  }

  navigateWithParams(newParams) {
    window.location.href = this.buildUrl(newParams);
  }
}
