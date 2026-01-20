// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import "./controllers";
import "preline/dist/preline.js";

const initPreline = () => {
  if (window.HSDropdown) {
    window.HSDropdown.autoInit();
  }
  if (window.HSAccordion) {
    window.HSAccordion.autoInit();
  }
  if (window.HSOverlay) {
    window.HSOverlay.autoInit();
  }
};

document.addEventListener("turbo:render", initPreline);
document.addEventListener("turbo:load", initPreline);
