import { Controller } from "@hotwired/stimulus";
import { Chart } from "chart.js/auto";

export default class extends Controller {
  connect() {
    const canvas = this.element.querySelector("canvas");

    if (canvas) {
      const data = JSON.parse(this.data.get("minutes-watched"));

      // Extract names and movie counts
      const labels = data.map(item => item.date);
      const dataset = data.map(item => item.minutes_watched);

      canvas.style.width = "400px";
      canvas.style.height = "300px";
      console.log(this)
      new Chart(canvas, {
        type: "line",
        data: {
          labels: labels,
          datasets: [
            {
              label: "Minutes Watched",
              data: dataset,
              backgroundColor: "rgba(75, 192, 192, 0.2)",
              borderColor: "rgba(75, 192, 192, 1)",
              borderWidth: 1
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
        }
      });
    } else {
      console.error("Canvas element not found");
    }
  }
}
