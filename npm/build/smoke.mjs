// smoke.mjs — post-build sanity check: the bundle exports the registrar and
// carries the controllers, and the stylesheet compiled real clowk utilities.
import { readFileSync } from "node:fs"

const js = readFileSync(new URL("../dist/clowk-phlex.js", import.meta.url), "utf8")
const css = readFileSync(new URL("../dist/core.css", import.meta.url), "utf8")

const checks = [
  ["JS exports registerClowkPhlex", js.includes("registerClowkPhlex")],
  ["JS bundles metrics-chart controller", js.includes("metrics-chart")],
  ["JS bundles the settings controller", js.includes("metrics-display-settings")],
  ["CSS compiled a clowk surface utility", /\.bg-clowk-surface\b/.test(css)],
  ["CSS compiled a clowk mono font utility", /\.font-clowk-mono\b/.test(css)],
  ["CSS carries the token layer", css.includes("--clowk-accent")]
]

let failed = 0
for (const [label, ok] of checks) {
  console.log(`${ok ? "✓" : "✗"} ${label}`)
  if (!ok) failed++
}

if (failed) {
  console.error(`\n${failed} smoke check(s) failed`)
  process.exit(1)
}
console.log("\nsmoke ok")
