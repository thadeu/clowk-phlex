import { describe, it, expect } from "vitest"
import { CHART_NS, nsKey, KEYS, getJSON, setJSON } from "../../src/lib/chart_storage.js"

describe("lib/chart_storage", () => {
  it("namespaces keys under one prefix", () => {
    expect(CHART_NS).toBe("charts")
    expect(nsKey("display")).toBe("charts:display")
  })

  it("exposes the canonical key set", () => {
    expect(KEYS.display).toBe("charts:display")
    expect(KEYS.sizes).toBe("charts:sizes:v3")
    expect(KEYS.collapsed).toBe("charts:collapsed")
    expect(KEYS.panelOptions).toBe("charts:panel-options")
  })

  it("round-trips JSON through the namespaced session store", () => {
    setJSON(KEYS.display, { metrics: { cols: 3 } })
    expect(getJSON(KEYS.display)).toEqual({ metrics: { cols: 3 } })
  })

  it("returns the fallback when unset", () => {
    expect(getJSON(KEYS.sizes)).toEqual({})
    expect(getJSON(KEYS.sizes, [])).toEqual([])
  })
})
