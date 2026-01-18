import { Controller } from "@hotwired/stimulus";
import { Chart } from "chart.js/auto";

export default class extends Controller {
  static values = { minutesWatched: Array };

  connect() {
    const canvas = this.element.querySelector("canvas");

    if (canvas) {
      const data = this.minutesWatchedValue;

      // Validate data
      if (!data || !Array.isArray(data)) {
        console.error("Invalid or missing data for chart");
        return;
      }

      // Group data by date and create datasets for each mate
      const labels = [...new Set(data.map((item) => item.date))];
      const mates = [...new Set(data.map((item) => item.name))];

      const datasets = mates.map((name) => {
        const mateData = data.filter((item) => item.name === name);
        return {
          label: name,
          data: labels.map((date) => {
            const entry = mateData.find((item) => item.date === date);
            return entry ? entry.minutes_watched : 0;
          }),
          borderColor: `rgba(${Math.floor(Math.random() * 255)}, ${Math.floor(Math.random() * 192)}, ${Math.floor(Math.random() * 192)}, 1)`,
          borderWidth: 1,
        };
      });

      // Style canvas
      canvas.style.display = "block";
      canvas.style.width = "100%";
      canvas.style.height = "400px";

      // Initialize chart
      new Chart(canvas, {
        type: "line",
        data: {
          labels: labels,
          datasets: datasets,
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              display: true,
              position: "top",
            },
          },
        },
      });
    } else {
      console.error("Canvas element not found");
    }
  }
}
