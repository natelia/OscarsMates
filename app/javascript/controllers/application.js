import { Application } from "@hotwired/stimulus"

const application = Application.start()

import ChartController from "./chart_controller";
application.register("chart", ChartController);

import ConfettiController from "./confetti_controller";
application.register("confetti", ConfettiController);

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
