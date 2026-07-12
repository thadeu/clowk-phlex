import { describe, it, expect, vi } from "vitest"

// SortableJS needs a real layout engine; jsdom has none. Stub it — the settings
// controller only calls Sortable.create(...).destroy().
vi.mock("sortablejs", () => ({ default: { create: () => ({ destroy() {} }) } }))

const { default: MetricsDisplaySettings } = await import("../../src/controllers/metrics_display_settings_controller.js")
const { KEYS, getJSON } = await import("../../src/lib/chart_storage.js")
const { mount } = await import("../helper.js")

const HTML = `
  <div data-controller="metrics-display-settings" data-metrics-display-settings-kind-value="metrics">
    <div data-metrics-display-settings-target="grid">
      <div data-metrics-display-settings-target="card" data-metric="a"
           data-action="click->metrics-display-settings#toggle">
        <span data-role="check"></span>
      </div>
      <div data-metrics-display-settings-target="card" data-metric="b"
           data-action="click->metrics-display-settings#toggle">
        <span data-role="check"></span>
      </div>
    </div>
    <button data-metrics-display-settings-target="colsBtn" data-cols="2"
            data-action="click->metrics-display-settings#selectCols">2</button>
    <button data-metrics-display-settings-target="colsBtn" data-cols="3"
            data-action="click->metrics-display-settings#selectCols">3</button>
    <button data-role="update-btn" data-action="click->metrics-display-settings#save">Update</button>
  </div>`

describe("metrics-display-settings controller", () => {
  it("commits { hidden, order, cols } and broadcasts the change on Update", async () => {
    let changed = false
    const listener = () => { changed = true }
    window.addEventListener("metrics-display:changed", listener)

    const { element } = await mount("metrics-display-settings", MetricsDisplaySettings, HTML)

    element.querySelector('[data-metric="a"]').click() // hide card A
    element.querySelector('[data-cols="3"]').click() // 3 columns
    element.querySelector('[data-role="update-btn"]').click() // commit

    expect(getJSON(KEYS.display).metrics).toEqual({
      hidden: ["a"],
      order: ["a", "b"],
      cols: 3
    })
    expect(changed).toBe(true)

    window.removeEventListener("metrics-display:changed", listener)
  })

  it("resets per-card resize spans when the column count changes", async () => {
    // simulate a prior manual resize + a prior column choice
    sessionStorage.setItem(KEYS.sizes, JSON.stringify({ metrics: { a: 20, b: 40 } }))
    sessionStorage.setItem(KEYS.display, JSON.stringify({ metrics: { hidden: [], order: [], cols: 3 } }))

    const { element } = await mount("metrics-display-settings", MetricsDisplaySettings, HTML)

    element.querySelector('[data-cols="2"]').click() // change 3 -> 2
    element.querySelector('[data-role="update-btn"]').click()

    // the stored resize spans for this kind are cleared, so cols wins
    expect(getJSON(KEYS.sizes).metrics).toBeUndefined()
    expect(getJSON(KEYS.display).metrics.cols).toBe(2)
  })

  it("keeps per-card resize spans when only visibility/order changes (cols unchanged)", async () => {
    sessionStorage.setItem(KEYS.sizes, JSON.stringify({ metrics: { a: 20 } }))
    sessionStorage.setItem(KEYS.display, JSON.stringify({ metrics: { hidden: [], order: [], cols: 2 } }))

    const { element } = await mount("metrics-display-settings", MetricsDisplaySettings, HTML)

    element.querySelector('[data-metric="b"]').click() // toggle visibility only
    element.querySelector('[data-role="update-btn"]').click()

    // cols didn't change (still 2) → sizes preserved
    expect(getJSON(KEYS.sizes).metrics).toEqual({ a: 20 })
  })
})
