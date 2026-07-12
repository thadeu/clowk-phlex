# clowk-phlex

> Phlex UI components with Stimulus behaviors — starting with a full charting toolkit.

`clowk-phlex` is a **dual-artifact** UI library. The markup is a Ruby gem; the
behavior and styles are an npm package. They are two halves of one library,
version-locked, and meet only at runtime through `data-*` attributes:

| Artifact | Registry | Ships |
| --- | --- | --- |
| `clowk-phlex` | RubyGems | Phlex view components (SVG/HTML markup) — **view only** |
| `@clowk/phlex` | npm | Stimulus controllers + Turbo actions + precompiled `clowk-phlex.css` |

**Charts** is the first module (area / line / bars, single & multi-series,
radial & linear gauges, number tiles, sparklines) with the full dashboard
feature set: range & interval pickers, a visibility / order / columns settings
panel, drag-to-resize, interactive legends, hover tooltips, and a maximize hook.
UI primitives (Button, Drawer, Sidebar, Dropdown, Table…) migrate in next under
the same namespaces.

## Install

```ruby
# Gemfile
gem "clowk-phlex"
```

```bash
pnpm add @clowk/phlex
```

```js
// your Stimulus entrypoint
import { registerClowkPhlex } from "@clowk/phlex"
import "@clowk/phlex/clowk-phlex.css"   // precompiled — no Tailwind @source needed

registerClowkPhlex(application)
```

## Usage

```ruby
class Dashboard < ApplicationView
  include Clowk::Phlex   # → short names: Charts::Card, UI::Dropdown, …

  def view_template
    render Charts::Card.new(label: "HOST · CPU", color: "#5B8DEF", unit: "%",
                            chart_type: "area", points: points, range_ms: range_ms)
  end
end
```

Components take **plain data** (hashes / kwargs) — no models, no DB, no app
routes. You bring the container (modal, drawer, page); the lib brings the
content and its behavior.

## Theming

The shipped CSS references `--color-clowk-*` design tokens. Override them to
retheme without touching Ruby:

```css
:root {
  --color-clowk-accent: #5b8def;
  --color-clowk-surface: #12151c;
}
```

Tailwind v4 is **optional** — needed only to extend components with your own
utility classes via the `class:` passthrough.

## Monorepo

```
clowk-phlex/
├─ gem/      # the Ruby gem (RubyGems)
├─ npm/      # the npm package (@clowk/phlex) — src + build; dist/ is gitignored
├─ docs/     # API reference + design decisions
├─ skills/   # Agent Skill for `npx skills add clowk/clowk-phlex`
└─ VERSION   # single source of truth for both artifacts
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for the build & release flow.

## Status

Early scaffolding — `0.0.0`. Not yet published.

## License

[MIT](LICENSE) © Thadeu Esteves
