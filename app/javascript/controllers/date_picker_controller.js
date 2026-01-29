import { Controller } from "@hotwired/stimulus";

// Custom Date Picker Controller
// Provides a Tailwind-styled date picker dropdown
export default class extends Controller {
  static targets = ["input", "dropdown", "monthYear", "grid"];
  static values = { date: String };

  connect() {
    this.selectedDate = this.inputTarget.value ? this.parseDate(this.inputTarget.value) : null;
    this.currentMonth = this.selectedDate ? new Date(this.selectedDate) : new Date();
    this.currentMonth.setDate(1); // Set to first day of month

    // Close dropdown when clicking outside
    this.outsideClickHandler = this.handleOutsideClick.bind(this);
    document.addEventListener("click", this.outsideClickHandler);
  }

  parseDate(dateString) {
    // Parse date string (YYYY-MM-DD) as local date, not UTC
    const [year, month, day] = dateString.split("-").map(Number);
    return new Date(year, month - 1, day);
  }

  formatDate(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const day = String(date.getDate()).padStart(2, "0");
    return `${year}-${month}-${day}`;
  }

  disconnect() {
    document.removeEventListener("click", this.outsideClickHandler);
  }

  handleOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.closeDropdown();
    }
  }

  toggleDropdown(event) {
    event.stopPropagation();
    const isHidden = this.dropdownTarget.classList.contains("hidden");
    if (isHidden) {
      this.openDropdown();
    } else {
      this.closeDropdown();
    }
  }

  openDropdown() {
    this.renderCalendar();
    this.dropdownTarget.classList.remove("hidden");
  }

  closeDropdown() {
    this.dropdownTarget.classList.add("hidden");
  }

  renderCalendar() {
    // Update month/year display
    const monthNames = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    this.monthYearTarget.textContent = `${monthNames[this.currentMonth.getMonth()]} ${this.currentMonth.getFullYear()}`;

    // Render calendar grid
    const firstDay = new Date(this.currentMonth);
    const lastDay = new Date(this.currentMonth.getFullYear(), this.currentMonth.getMonth() + 1, 0);

    const startDay = firstDay.getDay(); // 0 = Sunday
    const daysInMonth = lastDay.getDate();

    let html = "";

    // Day headers
    const dayNames = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"];
    dayNames.forEach((day) => {
      html += `<div class="date-weekday">${day}</div>`;
    });

    // Empty cells for days before month starts
    for (let i = 0; i < startDay; i++) {
      html += `<div></div>`;
    }

    // Days of the month
    const today = new Date();
    const todayStr = `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, "0")}-${String(today.getDate()).padStart(2, "0")}`;

    for (let day = 1; day <= daysInMonth; day++) {
      const date = new Date(this.currentMonth.getFullYear(), this.currentMonth.getMonth(), day);
      const dateStr = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, "0")}-${String(date.getDate()).padStart(2, "0")}`;

      const isToday = dateStr === todayStr;
      const isSelected = this.selectedDate && dateStr === this.formatDate(this.selectedDate);

      let classes = "date-day text-center py-2 text-sm cursor-pointer rounded-md transition-colors";

      if (isSelected) {
        classes += " date-selected";
      } else if (isToday) {
        classes += " date-today";
      }

      html += `<div class="${classes}" data-action="click->date-picker#selectDate" data-date="${dateStr}">${day}</div>`;
    }

    this.gridTarget.innerHTML = html;
  }

  selectDate(event) {
    const dateStr = event.currentTarget.dataset.date;
    this.selectedDate = this.parseDate(dateStr);
    this.inputTarget.value = dateStr;
    this.closeDropdown();

    // Trigger change event for form validation
    this.inputTarget.dispatchEvent(new Event("change", { bubbles: true }));
  }

  previousMonth() {
    this.currentMonth.setMonth(this.currentMonth.getMonth() - 1);
    this.renderCalendar();
  }

  nextMonth() {
    this.currentMonth.setMonth(this.currentMonth.getMonth() + 1);
    this.renderCalendar();
  }

  today() {
    const today = new Date();
    this.selectedDate = today;
    this.currentMonth = new Date(today);
    this.currentMonth.setDate(1);
    this.inputTarget.value = this.formatDate(today);
    this.closeDropdown();
    this.inputTarget.dispatchEvent(new Event("change", { bubbles: true }));
  }
}
