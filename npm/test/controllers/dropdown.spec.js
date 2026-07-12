import { describe, it, expect } from "vitest"
import Dropdown from "../../src/controllers/dropdown_controller.js"
import { mount } from "../helper.js"

const HTML = `
  <div data-controller="dropdown">
    <button data-action="click->dropdown#toggle">open</button>
    <div data-dropdown-target="menu" hidden>menu</div>
  </div>`

describe("dropdown controller", () => {
  it("toggles the menu open and closed", async () => {
    const { element } = await mount("dropdown", Dropdown, HTML)
    const menu = element.querySelector('[data-dropdown-target="menu"]')
    const button = element.querySelector("button")

    expect(menu.hidden).toBe(true)

    button.click()
    expect(menu.hidden).toBe(false)

    button.click()
    expect(menu.hidden).toBe(true)
  })
})
