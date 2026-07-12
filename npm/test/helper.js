import { Application } from "@hotwired/stimulus"
import { afterEach } from "vitest"

let current = null

// Stop the app while the DOM is still intact, so the next test's body reset
// doesn't fire Stimulus's MutationObserver against a torn-down environment.
afterEach(() => {
  if (current) {
    current.stop()
    current = null
  }
})

export function tick() {
  return new Promise((resolve) => setTimeout(resolve, 0))
}

// mount — start a Stimulus app with one controller registered, render `html`,
// and wait for connect. Stops any previously-mounted app so tests stay isolated.
export async function mount(identifier, controller, html) {
  if (current) current.stop()

  document.body.innerHTML = html
  current = Application.start()
  current.register(identifier, controller)
  await tick()

  const element = document.querySelector(`[data-controller~="${identifier}"]`)

  return { app: current, element }
}

// controllerFor — the connected controller instance for an element.
export function controllerFor(app, element, identifier) {
  return app.getControllerForElementAndIdentifier(element, identifier)
}
