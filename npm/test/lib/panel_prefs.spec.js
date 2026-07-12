import { describe, it, expect } from "vitest"
import { panelPref, setPanelPref } from "../../src/lib/panel_prefs.js"

describe("lib/panel_prefs", () => {
  it("returns the fallback when a pref is unset", () => {
    expect(panelPref("cpu", "dots", true)).toBe(true)
    expect(panelPref("cpu", "dots", false)).toBe(false)
  })

  it("persists and reads back a pref", () => {
    setPanelPref("cpu", "dots", false)
    expect(panelPref("cpu", "dots", true)).toBe(false)
  })

  it("clears a pref back to the fallback when set to null", () => {
    setPanelPref("cpu", "timeline", false)
    expect(panelPref("cpu", "timeline", true)).toBe(false)

    setPanelPref("cpu", "timeline", null)
    expect(panelPref("cpu", "timeline", true)).toBe(true)
  })

  it("keeps prefs isolated per panel key", () => {
    setPanelPref("a", "dots", false)
    expect(panelPref("b", "dots", true)).toBe(true)
  })
})
