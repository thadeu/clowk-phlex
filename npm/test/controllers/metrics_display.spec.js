import { describe, it, expect } from "vitest"
import MetricsDisplay from "../../src/controllers/metrics_display_controller.js"
import { KEYS } from "../../src/lib/chart_storage.js"
import { mount } from "../helper.js"

const HTML = `
  <div data-controller="metrics-display" data-metrics-display-kind-value="metrics">
    <div data-metrics-display-target="grid">
      <div data-metrics-display-target="card" data-metric-key="a"></div>
      <div data-metrics-display-target="card" data-metric-key="b"></div>
      <div data-metrics-display-target="card" data-metric-key="c"></div>
    </div>
  </div>`

describe("metrics-display controller", () => {
  it("lays out the resize grid on the desktop breakpoint", async () => {
    const { element } = await mount("metrics-display", MetricsDisplay, HTML)
    const grid = element.querySelector('[data-metrics-display-target="grid"]')
    const cardA = element.querySelector('[data-metric-key="a"]')

    expect(grid.style.gridTemplateColumns).toBe("repeat(60, minmax(0, 1fr))")
    expect(cardA.style.gridColumn).toMatch(/span \d+/)
  })

  it("applies the operator's stored hidden set + column preference", async () => {
    sessionStorage.setItem(
      KEYS.display,
      JSON.stringify({ metrics: { hidden: ["b"], order: [], cols: 3 } })
    )

    const { element } = await mount("metrics-display", MetricsDisplay, HTML)
    const cardA = element.querySelector('[data-metric-key="a"]')
    const cardB = element.querySelector('[data-metric-key="b"]')

    expect(cardB.hidden).toBe(true)
    expect(cardA.hidden).toBe(false)
  })
})
