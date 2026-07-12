import { describe, it, expect } from "vitest"
import MetricsSection from "../../src/controllers/metrics_section_controller.js"
import { KEYS, getJSON } from "../../src/lib/chart_storage.js"
import { mount } from "../helper.js"

const HTML = `
  <div data-controller="metrics-section" data-metrics-section-id-value="sec-1">
    <button data-action="click->metrics-section#toggle">eye</button>
    <div data-metrics-section-target="body">charts</div>
  </div>`

describe("metrics-section controller", () => {
  it("collapses the body and persists the collapsed id", async () => {
    const { element } = await mount("metrics-section", MetricsSection, HTML)
    const body = element.querySelector('[data-metrics-section-target="body"]')
    const button = element.querySelector("button")

    expect(body.hidden).toBe(false)

    button.click()
    expect(body.hidden).toBe(true)
    expect(getJSON(KEYS.collapsed, [])).toContain("sec-1")

    button.click()
    expect(body.hidden).toBe(false)
    expect(getJSON(KEYS.collapsed, [])).not.toContain("sec-1")
  })

  it("restores a persisted collapsed state on connect", async () => {
    sessionStorage.setItem(KEYS.collapsed, JSON.stringify(["sec-1"]))

    const { element } = await mount("metrics-section", MetricsSection, HTML)
    const body = element.querySelector('[data-metrics-section-target="body"]')

    expect(body.hidden).toBe(true)
  })
})
