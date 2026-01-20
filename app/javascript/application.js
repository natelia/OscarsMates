// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import "./controllers";
import "preline/dist/preline.js";
import { createIcons, icons } from "lucide";

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

const initLucideIcons = () => {
  createIcons({
    icons: icons,
    nameAttr: "data-lucide",
    attrs: {
      class: "inline-flex w-5 h-5",
    },
  });
};

document.addEventListener("turbo:render", initPreline);
document.addEventListener("turbo:load", initPreline);
document.addEventListener("turbo:render", initLucideIcons);
document.addEventListener("turbo:load", initLucideIcons);
