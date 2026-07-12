import { describe, it, expect, vi } from "vitest"
import PanelOptions from "../../src/controllers/panel_options_controller.js"
import { panelPref } from "../../src/lib/panel_prefs.js"
import { mount } from "../helper.js"

const HTML = `
  <div data-controller="panel-options" data-panel-options-key-value="cpu">
    <input type="checkbox" data-panel-options-target="dots"
           data-action="change->panel-options#toggleDots" checked>
  </div>`

describe("panel-options controller", () => {
  it("toggling dots off persists the pref and broadcasts a keyed event", async () => {
    const events = []
    const listener = (e) => events.push(e.detail)
    window.addEventListener("panel-options:change", listener)

    const { element } = await mount("panel-options", PanelOptions, HTML)
    const checkbox = element.querySelector('[data-panel-options-target="dots"]')

    checkbox.checked = false
    checkbox.dispatchEvent(new Event("change", { bubbles: true }))

    expect(events.at(-1)).toMatchObject({ key: "cpu", dots: false })
    expect(panelPref("cpu", "dots", true)).toBe(false)

    window.removeEventListener("panel-options:change", listener)
  })
})
