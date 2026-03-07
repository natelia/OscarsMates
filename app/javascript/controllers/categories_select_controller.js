import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "dropdown", "option", "pills"];

  connect() {
    this.boundClose = this.closeDropdown.bind(this);
    this.boundReposition = this.positionDropdown.bind(this);
    document.addEventListener("click", this.boundClose);
    window.addEventListener("scroll", this.boundReposition, true);
    window.addEventListener("resize", this.boundReposition);
    this.renderPills();
  }

  disconnect() {
    document.removeEventListener("click", this.boundClose);
    window.removeEventListener("scroll", this.boundReposition, true);
    window.removeEventListener("resize", this.boundReposition);
  }

  handleFocus(_event) {
    this.openDropdown();
  }

  handleInput(event) {
    this.openDropdown();
    this.filterOptions(event.target.value);
  }

  handleClick(event) {
    event.stopPropagation();
    this.openDropdown();
  }

  openDropdown() {
    this.dropdownTarget.classList.remove("hidden");
    this.positionDropdown();
  }

  closeDropdown(event) {
    if (!this.element.contains(event.target)) {
      this.dropdownTarget.classList.add("hidden");
      this.inputTarget.value = "";
      this.filterOptions("");
    }
  }

  positionDropdown() {
    if (this.dropdownTarget.classList.contains("hidden")) return;

    const inputRect = this.inputTarget.getBoundingClientRect();
    const dropdownHeight = 320; // max-height of dropdown
    const spaceBelow = window.innerHeight - inputRect.bottom;
    const spaceAbove = inputRect.top;

    // Position above if not enough space below
    if (spaceBelow < dropdownHeight && spaceAbove > spaceBelow) {
      this.dropdownTarget.style.top = `${inputRect.top - dropdownHeight - 4}px`;
    } else {
      this.dropdownTarget.style.top = `${inputRect.bottom + 4}px`;
    }

    this.dropdownTarget.style.left = `${inputRect.left}px`;
    this.dropdownTarget.style.width = `${inputRect.width}px`;
  }

  filterOptions(query) {
    const searchText = query.toLowerCase();
    this.optionTargets.forEach((option) => {
      const text = option.textContent.toLowerCase();
      option.style.display = text.includes(searchText) ? "" : "none";
    });
  }

  toggleCategory(event) {
    event.preventDefault();
    event.stopPropagation();
    const checkbox = event.currentTarget.querySelector('input[type="checkbox"]');
    checkbox.checked = !checkbox.checked;
    this.renderPills();
    this.inputTarget.value = "";
    this.filterOptions("");
  }

  removeCategory(event) {
    event.preventDefault();
    event.stopPropagation();
    const categoryId = event.currentTarget.dataset.categoryId;
    const checkbox = this.optionTargets
      .find((opt) => opt.querySelector("input").value === categoryId)
      ?.querySelector("input");

    if (checkbox) {
      checkbox.checked = false;
      this.renderPills();
    }
  }

  renderPills() {
    const selected = this.getSelected();

    // Render pills
    this.pillsTarget.innerHTML = "";
    selected.forEach((category) => {
      const pill = document.createElement("span");
      pill.className =
        "inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-[var(--oscar-gold-light)] border border-[var(--oscar-gold)] text-sm font-medium";
      pill.innerHTML = `
        ${category.name}
        <button type="button" class="hover:text-red-600" data-category-id="${category.id}" data-action="click->categories-select#removeCategory">
          <i data-lucide="x" class="w-3.5 h-3.5"></i>
        </button>
      `;
      this.pillsTarget.appendChild(pill);
    });

    if (window.lucide) window.lucide.createIcons();
  }

  getSelected() {
    return this.optionTargets
      .map((opt) => {
        const checkbox = opt.querySelector('input[type="checkbox"]');
        return checkbox.checked ? { id: checkbox.value, name: checkbox.dataset.name } : null;
      })
      .filter((cat) => cat !== null);
  }
}
