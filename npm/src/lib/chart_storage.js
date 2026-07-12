// chart_storage — the SINGLE namespace + persistence seam for the chart lib.
//
// Everything the charts persist browser-side (panel prefs, card visibility /
// order / columns, per-card resize spans, collapsed sections, drawer width)
// goes through here, keyed under one prefix. This is the isolation point for
// extracting the lib into a gem: rebrand the whole namespace by changing
// CHART_NS alone — no controller edits.
//
// Storage is best-effort: every read returns a fallback and every write is a
// silent no-op when Web Storage is unavailable (private mode, quota, disabled).
// Persistence is a UI-pref convenience, never a source of truth.

import { readJSON, writeJSON } from "./storage"

// CHART_NS — the one prefix all chart storage keys hang off. Neutral (not app-
// specific) so the lib drops into any host. A gem consumer overrides this once.
export const CHART_NS = "charts"

// nsKey — namespace a bare suffix, e.g. nsKey("display") → "charts:display".
export function nsKey(suffix) {
  return `${CHART_NS}:${suffix}`
}

// The canonical keys, in one place so the whole lib agrees on them.
export const KEYS = {
  display: nsKey("display"), // { [kind]: { hidden, order, cols } }
  sizes: nsKey("sizes:v3"), // { [kind]: { [metricKey]: span } }
  collapsed: nsKey("collapsed"), // [ sectionId, ... ]
  panelOptions: nsKey("panel-options"), // { [panelKey]: { dots, timeline, ... } }
  drawerWidth: nsKey("drawer-width") // { [storageKey]: px }
}

// getJSON / setJSON — thin sessionStorage helpers over storage.js, so callers
// stay one line and never re-implement the try/catch.
export function getJSON(key, fallback = {}) {
  return readJSON(sessionStorage, key, { fallback }) || fallback
}

export function setJSON(key, value) {
  return writeJSON(sessionStorage, key, value)
}
