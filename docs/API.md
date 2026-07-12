# clowk-phlex API

Two artifacts, one library:

- **gem `clowk-phlex`** — Phlex components (markup + `data-*`). View only.
- **npm `@clowk/phlex`** — Stimulus controllers + precompiled `clowk-phlex.css`.

## Setup

```ruby
gem "clowk-phlex"
```

```js
import { registerClowkPhlex } from "@clowk/phlex"
import "@clowk/phlex/clowk-phlex.css"
registerClowkPhlex(application) // your Stimulus app
```

```ruby
class Dashboard < ApplicationView
  include Clowk::Phlex # short names: Charts::Card, UI::Switch, …
end
```

## Contract

- Components take **plain data** (hashes / kwargs). No models, no DB.
- **You bring the containers.** The lib has no modal / drawer shells — it renders
  content + `data-*`; the host wraps it. See *Fullscreen* and *Settings* below.
- **Behavior is opt-in via JS.** Markup renders server-side; interactivity turns
  on once `registerClowkPhlex` runs. The `data-controller` identifiers
  (`metrics-chart`, `metrics-display`, `dropdown`, …) are internal plumbing.

## Components

### `Charts::TimeSeries`
The engine. `points:` (single) or `series:` (multi) of `{ ts:, value:, formatted: }`.
`style:` `:area | :line | :bars`. `axes:`, `height:`, `range_ms:`, `key:`.
Multi-series draws an interactive legend (click = hide, hover = spotlight).

### `Charts::Card`
The engine wrapped with a header (label + headline + min/avg/max footer), an
optional kebab ("Show dots"), and an optional maximize button. `chart_type:`
`"area" | "line" | "bars" | "gauge_radial" | "gauge_linear"`; `series:` for
multi; `gauge_bars:` for a stacked linear gauge; `metric:` keys it into the
display store; `resizable:`; `expand_url:` (see *Fullscreen*).

### `Charts::NumberCard`
Big-number tile + optional trend timeline. Single (`series:` = points) or
multi-pod (`numbers:` + `series:` = per-pod series). Timeline toggles via kebab.

### `Charts::{GaugeRadial, GaugeLinear}`
Capacity gauges (amber >70%, red >90%). `GaugeLinear` also takes `bars:` to
stack one labeled capacity bar per row.

### `Charts::Sparkline`
Tiny inline area+line for stat tiles. `points:` (bare numbers or `{ ts, value }`).

### `Charts::ChartShape`
The type glyphs (area / bars / line / gauges). `ChartShape::METRIC_TYPES` is the
canonical list the `TypePicker` iterates.

### Controls
`Charts::RangePicker` (preset pills + custom window), `Charts::IntervalPicker`
(bucket size), `Charts::TypePicker` (chart type). Each takes an injected
`base_path:` + `extra_params:` and builds its own URLs — no host routes needed.

### `Charts::DisplaySettings`
The visibility / order / columns panel body (drag to reorder, click to toggle,
pick columns). `kind:` (storage slice) + `items:` (`{ metric:, label:, color:,
unit: }`). Renders the panel only — wrap it in your own drawer.

### `UI::Switch`
macOS-style toggle backed by a real checkbox.

## Fullscreen (host owns the modal)

`Card.new(..., expand_url: "/your/endpoint?metric=cpu")` renders a maximize
button linking to `expand_url`. The lib does not open a modal — point the URL at
your own endpoint (Turbo Stream, page, or a click handler you attach) and render
a taller `Charts::TimeSeries` inside your container. Omit `expand_url` for no
button.

## Theming

The stylesheet references `--clowk-*` tokens. Override them to retheme, and set
`data-theme="light"` on `:root` for the light palette:

```css
:root { --clowk-accent: #5b8def; --clowk-surface: #12151c; }
```

Tailwind v4 is optional for consumers — needed only to extend components with
extra utilities via the `class:` passthrough.

## Format helper

`Clowk::Phlex::Charts::Format.percent(0.05) # => "0.05%"` — magnitude-adaptive
formatting, safe to use for your own labels.
