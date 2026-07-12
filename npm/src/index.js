// @clowk/phlex — the behavior half of clowk-phlex. Stimulus controllers that
// bring the Ruby-rendered chart markup to life (hover, resize, legends, pickers,
// settings, sections). The gem renders `data-controller="…"` attributes; this
// package registers the matching controllers.
//
//   import { registerClowkPhlex } from "@clowk/phlex"
//   import "@clowk/phlex/clowk-phlex.css"
//   registerClowkPhlex(application)
//
// The modal/drawer SHELLS are intentionally NOT here — the host owns those
// containers. This ships only content behavior.

import MetricsChart from "./controllers/metrics_chart_controller.js"
import MetricsDisplay from "./controllers/metrics_display_controller.js"
import MetricsDisplaySettings from "./controllers/metrics_display_settings_controller.js"
import MetricsSection from "./controllers/metrics_section_controller.js"
import TimeRangeFilter from "./controllers/time_range_filter_controller.js"
import PanelOptions from "./controllers/panel_options_controller.js"
import NumberCard from "./controllers/number_card_controller.js"
import Dropdown from "./controllers/dropdown_controller.js"
import Popover from "./controllers/popover_controller.js"

// The identifier each controller registers under — must match the
// `data-controller` strings the gem's Phlex components emit.
export const CONTROLLERS = {
  "metrics-chart": MetricsChart,
  "metrics-display": MetricsDisplay,
  "metrics-display-settings": MetricsDisplaySettings,
  "metrics-section": MetricsSection,
  "time-range-filter": TimeRangeFilter,
  "panel-options": PanelOptions,
  "number-card": NumberCard,
  "dropdown": Dropdown,
  "popover": Popover
}

// registerClowkPhlex — register every clowk-phlex controller on a Stimulus
// application. Call once during boot.
export function registerClowkPhlex(application) {
  for (const [name, controller] of Object.entries(CONTROLLERS)) {
    application.register(name, controller)
  }

  return application
}

export {
  MetricsChart, MetricsDisplay, MetricsDisplaySettings, MetricsSection,
  TimeRangeFilter, PanelOptions, NumberCard, Dropdown, Popover
}

export default registerClowkPhlex
