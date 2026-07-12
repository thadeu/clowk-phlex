import { describe, it, expect } from "vitest"
import NumberCard from "../../src/controllers/number_card_controller.js"
import { mount } from "../helper.js"

const HTML = `
  <div data-controller="number-card" data-number-card-key-value="fs">
    <div data-number-card-target="timeline">sparkline</div>
  </div>`

describe("number-card controller", () => {
  it("hides / reveals its timeline in response to a keyed panel-options event", async () => {
    const { element } = await mount("number-card", NumberCard, HTML)
    const timeline = element.querySelector('[data-number-card-target="timeline"]')

    expect(timeline.hidden).toBe(false)

    window.dispatchEvent(new CustomEvent("panel-options:change", { detail: { key: "fs", timeline: false } }))
    expect(timeline.hidden).toBe(true)

    window.dispatchEvent(new CustomEvent("panel-options:change", { detail: { key: "fs", timeline: true } }))
    expect(timeline.hidden).toBe(false)
  })

  it("ignores events for a different panel key", async () => {
    const { element } = await mount("number-card", NumberCard, HTML)
    const timeline = element.querySelector('[data-number-card-target="timeline"]')

    window.dispatchEvent(new CustomEvent("panel-options:change", { detail: { key: "other", timeline: false } }))
    expect(timeline.hidden).toBe(false)
  })
})
