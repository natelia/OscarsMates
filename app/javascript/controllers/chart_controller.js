import { Controller } from "@hotwired/stimulus";
import { Chart } from "chart.js/auto";

export default class extends Controller {
  connect() {

    this.element.style.width = "400px";
    this.element.style.height = "300px";

    new Chart(this.element, {
      type: "bar",
      data: {
        labels: ["Red", "Blue", "Yellow"],
        datasets: [
          {
            label: "Test Dataset",
            data: [10, 20, 30],
            backgroundColor: ["red", "blue", "yellow"],
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false, 
      }
    });
  }
}
