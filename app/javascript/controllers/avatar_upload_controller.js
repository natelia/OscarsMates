import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "preview"];

  preview() {
    const file = this.inputTarget.files[0];
    if (!file) return;

    // Validate file type
    const validTypes = ["image/png", "image/jpeg", "image/gif", "image/webp"];
    if (!validTypes.includes(file.type)) {
      alert("Please select a PNG, JPG, GIF, or WebP image.");
      this.inputTarget.value = "";
      return;
    }

    // Validate file size (5MB)
    const maxSize = 5 * 1024 * 1024;
    if (file.size > maxSize) {
      alert("Image must be less than 5MB.");
      this.inputTarget.value = "";
      return;
    }

    // Show preview
    const reader = new FileReader();
    reader.onload = (e) => {
      const container = this.previewTarget.querySelector(".avatar-component");
      if (!container) return;

      // Find existing image or initials div
      const existingImg = container.querySelector("img");
      const initialsDiv = container.querySelector("div:not(.absolute)");

      if (existingImg) {
        // Update existing image
        existingImg.src = e.target.result;
      } else if (initialsDiv) {
        // Replace initials with new image
        const newImg = document.createElement("img");
        newImg.src = e.target.result;
        newImg.className = "w-30 h-30 rounded-full object-cover ring-2 ring-white shadow-sm";
        initialsDiv.replaceWith(newImg);
      }
    };
    reader.readAsDataURL(file);
  }
}
