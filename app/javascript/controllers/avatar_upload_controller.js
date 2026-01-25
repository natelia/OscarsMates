import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "preview", "saveButton"];

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
      // Try profile avatar structure first
      const profileImg = this.previewTarget.querySelector(".profile-avatar-img");
      const profilePlaceholder = this.previewTarget.querySelector(".profile-avatar-placeholder");

      if (profileImg) {
        profileImg.src = e.target.result;
        profileImg.style.objectFit = "cover";
        profileImg.style.objectPosition = "center";
        return;
      } else if (profilePlaceholder) {
        const newImg = document.createElement("img");
        newImg.src = e.target.result;
        newImg.className = "profile-avatar-img";
        newImg.style.objectFit = "cover";
        newImg.style.objectPosition = "center";
        profilePlaceholder.replaceWith(newImg);
        return;
      }

      // Fall back to avatar-component structure
      const container = this.previewTarget.querySelector(".avatar-component");
      if (!container) return;

      // Find existing image or initials div
      const existingImg = container.querySelector("img");
      const initialsDiv = container.querySelector("div:not(.absolute)");

      if (existingImg) {
        // Update existing image - ensure object-fit cover for 1:1 ratio
        existingImg.src = e.target.result;
        existingImg.style.objectFit = "cover";
        existingImg.style.objectPosition = "center";
      } else if (initialsDiv) {
        // Get the size from the initials div (use computed size)
        const size = initialsDiv.offsetWidth || 100;

        // Replace initials with new image, keeping the same class
        const newImg = document.createElement("img");
        newImg.src = e.target.result;
        newImg.className = initialsDiv.className.replace(
          "flex items-center justify-center text-white font-semibold",
          "object-cover object-center"
        );
        newImg.style.objectFit = "cover";
        newImg.style.objectPosition = "center";
        initialsDiv.replaceWith(newImg);
      }
    };
    reader.readAsDataURL(file);
  }

  submit() {
    const file = this.inputTarget.files[0];
    if (!file) return;

    // Auto-submit the form
    this.element.requestSubmit();
  }

  showSaveButton() {
    if (this.hasSaveButtonTarget) {
      this.saveButtonTarget.classList.remove("hidden");
    }
  }
}
