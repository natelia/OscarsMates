// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"

// Initialize Bootstrap dropdowns on Turbo page loads
document.addEventListener("turbo:load", () => {
  // Initialize all dropdowns
  const dropdownTriggerList = document.querySelectorAll('[data-bs-toggle="dropdown"]')
  dropdownTriggerList.forEach(el => new bootstrap.Dropdown(el))

  // Initialize all collapses
  const collapseTriggerList = document.querySelectorAll('[data-bs-toggle="collapse"]')
  collapseTriggerList.forEach(el => new bootstrap.Collapse(el, { toggle: false }))
})