import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"
import { KEYS, getJSON, setJSON } from "../lib/chart_storage"

// MetricsDisplaySettingsController — the "Settings" drawer body for the chart
// grid. A generic, domain-agnostic panel (portable → gem): it lists every card
// on the page as a tile and lets the operator
//
//   1. toggle a card's visibility  (click a tile)
//   2. reorder the cards           (drag the grip — SortableJS)
//   3. pick the column count       (the Columns pills)
//
// On "Update" it commits { hidden, order, cols } to the SHARED display store
// (KEYS.display, keyed by `kind`) and fires `metrics-display:changed`. The
// MetricsDisplayController — reading the same key — re-applies live: no reload,
// no backend. That storage+event contract is the ONLY coupling between the two
// controllers, so either can be swapped independently.
//
// Storage shape:  { [kind]: { hidden: [key,…], order: [key,…], cols: N } }
export default class extends Controller {
  static targets = ["grid", "card", "colsBtn"]
  static values  = { kind: String }

  connect() {
    const cfg = this.readConfig()

    this.cols = cfg.cols || 2
    this.hydrate(cfg)
    this.paintCols()

    // Reorder the tiles to match the saved order so the drawer mirrors the grid.
    this.applyOrder(cfg.order)

    this.sortable = Sortable.create(this.gridTarget, {
      animation: 150,
      handle: "[data-role='drag-handle']",
      ghostClass: "opacity-40"
    })
  }

  disconnect() {
    this.sortable?.destroy()
  }

  // toggle — flip one card's visibility (staged; committed on Update).
  toggle(event) {
    if (event.target.closest("[data-role='drag-handle']")) return

    const card = event.currentTarget

    this.setHidden(card, card.dataset.hidden !== "true")
  }

  selectCols(event) {
    this.cols = parseInt(event.currentTarget.dataset.cols, 10) || 2
    // Any click on a column button is an explicit "lay it out uniformly" intent
    // — even re-picking the current count — so the next save resets manual
    // resizes. (Tracking a change in value alone missed the re-pick case.)
    this.colsTouched = true
    this.paintCols()
  }

  // save — commit { hidden, order, cols } and tell the grid to re-apply.
  save() {
    const hidden = this.cardTargets
      .filter(c => c.dataset.hidden === "true")
      .map(c => c.dataset.metric)

    const order = this.cardTargets.map(c => c.dataset.metric)

    const store = getJSON(KEYS.display, {})

    store[this.kindValue] = { hidden, order, cols: this.cols }
    setJSON(KEYS.display, store)

    // Picking a column count is a "lay it out in N uniform columns" intent, so
    // it must supersede any manual per-card resize spans — otherwise the stored
    // sizes win and the column change looks like it did nothing. Reset whenever
    // the operator touched the Columns picker this session; a pure
    // visibility/order update leaves resizes intact.
    if (this.colsTouched) {
      const sizes = getJSON(KEYS.sizes, {})

      delete sizes[this.kindValue]
      setJSON(KEYS.sizes, sizes)
      this.colsTouched = false
    }

    window.dispatchEvent(new CustomEvent("metrics-display:changed"))
    this.flashUpdate()
  }

  // ── internals ──────────────────────────────────────────────────────────────

  hydrate(cfg) {
    const hidden = new Set(cfg.hidden)

    this.cardTargets.forEach(card => {
      this.setHidden(card, hidden.has(card.dataset.metric))
    })
  }

  setHidden(card, isHidden) {
    card.dataset.hidden = isHidden ? "true" : "false"
    card.classList.toggle("opacity-45", isHidden)

    const check = card.querySelector("[data-role='check']")

    if (check) check.classList.toggle("hidden", isHidden)
  }

  applyOrder(order) {
    if (!order || order.length === 0) return

    const byMetric = new Map(this.cardTargets.map(c => [c.dataset.metric, c]))

    order.forEach(metric => {
      const card = byMetric.get(metric)

      if (card) this.gridTarget.appendChild(card)
    })
  }

  paintCols() {
    this.colsBtnTargets.forEach(btn => {
      const active = parseInt(btn.dataset.cols, 10) === this.cols

      btn.classList.toggle("border-voodu-accent-line", active)
      btn.classList.toggle("bg-voodu-accent-dim", active)
      btn.classList.toggle("text-voodu-accent-2", active)
      btn.classList.toggle("border-voodu-border", !active)
    })
  }

  flashUpdate() {
    if (!this.hasUpdateBtnTarget) return

    const btn = this.updateBtnTarget
    const label = btn.textContent

    btn.textContent = "Applied ✓"
    setTimeout(() => { btn.textContent = label }, 1100)
  }

  get hasUpdateBtnTarget() {
    return !!this.element.querySelector("[data-role='update-btn']")
  }

  get updateBtnTarget() {
    return this.element.querySelector("[data-role='update-btn']")
  }

  readConfig() {
    const raw = getJSON(KEYS.display, {})[this.kindValue]

    if (!raw) {
      return {
        hidden: this.cardTargets.filter(c => c.dataset.defaultVisible === "false").map(c => c.dataset.metric),
        order: [],
        cols: 2
      }
    }

    return { hidden: raw.hidden || [], order: raw.order || [], cols: raw.cols || 2 }
  }
}
