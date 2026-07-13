# @clowk/phlex

> The **behavior + styles** half of [`clowk-phlex`](https://github.com/thadeu/clowk-phlex) — Stimulus controllers, Turbo actions, and a precompiled stylesheet for the Phlex chart components.

`clowk-phlex` is a **dual-artifact** UI library. The markup ships as a Ruby gem
([`clowk-phlex`](https://rubygems.org/gems/clowk-phlex)); this npm package ships
the behavior and styles. They are version-locked and meet only at runtime through
`data-*` attributes.

| Artifact | Registry | Ships |
| --- | --- | --- |
| `clowk-phlex` | RubyGems | Phlex view components (SVG/HTML markup) — **view only** |
| `@clowk/phlex` | npm | Stimulus controllers + Turbo actions + precompiled `clowk-phlex.css` |

## Install

```bash
pnpm add @clowk/phlex
```

```js
// your Stimulus entrypoint
import { registerClowkPhlex } from "@clowk/phlex"
import "@clowk/phlex/clowk-phlex.css"   // precompiled — no Tailwind @source needed

registerClowkPhlex(application)
```

`registerClowkPhlex(application)` registers every controller the chart components
emit (`metrics-chart`, `metrics-display`, `metrics-display-settings`,
`metrics-section`, `time-range-filter`, `panel-options`, `number-card`,
`dropdown`, `popover`). The Ruby gem renders the matching `data-controller`
markup; you don't wire anything up by hand.

## What's in the box

- **`dist/clowk-phlex.js`** — the Stimulus controllers + `registerClowkPhlex`,
  bundled with esbuild. Stimulus / Turbo / sortablejs are kept external (peer deps).
- **`dist/clowk-phlex.css`** — the design tokens (`--clowk-*`) plus every utility
  class the Phlex components emit, precompiled by scanning the gem's components.
  Consumers need **no** Tailwind `@source` of the gem.

## Theming

Override the `--color-clowk-*` / `--clowk-*` tokens to retheme without touching
Ruby:

```css
:root {
  --color-clowk-accent: #5b8def;
  --color-clowk-surface: #12151c;
}
```

## Peer setup

Bring your own `@hotwired/stimulus` (and `@hotwired/turbo-rails` if you use the
Turbo stream actions). `sortablejs` is used for drag-to-resize and is external too.

## License

[MIT](https://github.com/thadeu/clowk-phlex/blob/main/LICENSE) © Thadeu Esteves
