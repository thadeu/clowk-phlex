import { beforeEach } from "vitest"

// Stimulus's UMD build references bare DOM globals (Node, Element…) that jsdom
// exposes only on `window`. Surface them globally so the MutationObserver
// callback doesn't throw during connect/teardown.
for (const name of ["Node", "Element", "HTMLElement", "MutationObserver", "CustomEvent", "Event"]) {
  if (typeof globalThis[name] === "undefined" && typeof window[name] !== "undefined") {
    globalThis[name] = window[name]
  }
}

// jsdom doesn't implement these; the controllers touch them.
if (!window.matchMedia) {
  window.matchMedia = (query) => ({
    matches: true,
    media: query,
    addEventListener() {},
    removeEventListener() {},
    addListener() {},
    removeListener() {}
  })
}

if (!global.ResizeObserver) {
  global.ResizeObserver = class {
    observe() {}
    unobserve() {}
    disconnect() {}
  }
}

beforeEach(() => {
  sessionStorage.clear()
  localStorage.clear()
  document.body.innerHTML = ""
})
