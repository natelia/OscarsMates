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

  toggleService(event) {
    event.preventDefault();
    event.stopPropagation();
    const checkbox = event.currentTarget.querySelector('input[type="checkbox"]');
    checkbox.checked = !checkbox.checked;
    this.renderPills();
    this.inputTarget.value = "";
    this.filterOptions("");
  }

  removeService(event) {
    event.preventDefault();
    event.stopPropagation();
    const service = event.currentTarget.dataset.service;
    const checkbox = this.optionTargets
      .find((opt) => opt.querySelector("input").value === service)
      ?.querySelector("input");

    if (checkbox) {
      checkbox.checked = false;
      this.renderPills();
    }
  }

  renderPills() {
    const selected = this.getSelected();

    // Update hidden fields
    this.element
      .querySelectorAll('input[name="movie[streaming_services_array][]"]')
      .forEach((el) => el.remove());
    if (selected.length === 0) {
      const input = document.createElement("input");
      input.type = "hidden";
      input.name = "movie[streaming_services_array][]";
      input.value = "";
      this.element.appendChild(input);
    } else {
      selected.forEach((service) => {
        const input = document.createElement("input");
        input.type = "hidden";
        input.name = "movie[streaming_services_array][]";
        input.value = service;
        this.element.appendChild(input);
      });
    }

    // Render pills
    this.pillsTarget.innerHTML = "";
    selected.forEach((service) => {
      const pill = document.createElement("span");
      pill.className =
        "inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-[var(--oscar-gold-light)] border border-[var(--oscar-gold)] text-sm font-medium";
      pill.innerHTML = `
        ${service}
        <button type="button" class="hover:text-red-600" data-service="${service}" data-action="click->streaming-select#removeService">
          <i data-lucide="x" class="w-3.5 h-3.5"></i>
        </button>
      `;
      this.pillsTarget.appendChild(pill);
    });

    if (window.lucide) window.lucide.createIcons();
  }

  getSelected() {
    return this.optionTargets
      .map((opt) => opt.querySelector('input[type="checkbox"]'))
      .filter((cb) => cb.checked)
      .map((cb) => cb.value);
  }
}
