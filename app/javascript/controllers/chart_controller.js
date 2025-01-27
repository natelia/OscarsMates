import { Controller } from "@hotwired/stimulus";
import { Chart } from "chart.js/auto";

export default class extends Controller {
  connect() {
    const canvas = this.element.querySelector("canvas");

    if (canvas) {
      const data = JSON.parse(this.data.get("minutes-watched"));

      // Group data by date and create datasets for each mate
      const labels = [...new Set(data.map(item => item.date))];
      const mates = [...new Set(data.map(item => item.name))];
      
      const datasets = mates.map(name => {
        const mateData = data.filter(item => item.name === name);
        return {
          label: name,
          data: labels.map(date => {
            const entry = mateData.find(item => item.date === date);
            return entry ? entry.minutes_watched : 0;
          }),
          borderColor: `rgba(${Math.floor(Math.random() * 255)}, ${Math.floor(Math.random() * 192)}, ${Math.floor(Math.random() * 192)}, 1)`,
          borderWidth: 1
        };
      });

      canvas.style.width = "400px";
      canvas.style.height = "300px";
      console.log(data)
      new Chart(canvas, {
        type: "line",
        data: {
          labels: labels,
          datasets: datasets
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
