# Changelog

All notable changes to this project are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
The `clowk-phlex` gem and the `@clowk/phlex` npm package share this version.

## [Unreleased]

## [0.1.2] - 2026-07-13

### Added
- npm package now ships a `README.md` so the npmjs.org page has install/usage docs
  (the tarball previously shipped only `dist/`).

### Changed
- Root `README.md` status reflects the published state on both registries.

## [0.1.1] - 2026-07-13

### Fixed
- Point `repository.url` / `homepage` at `thadeu/clowk-phlex` so npm provenance
  verification passes (it must match the repo the release runs from). npm 0.1.0
  never published; 0.1.1 is the first npm release. Gem 0.1.0 already shipped.

## [0.1.0] - 2026-07-12

First release — the chart toolkit extracted from the dialive app and validated
end-to-end by consuming it back in that app.

### Added
- Repository scaffold: monorepo layout (`gem/`, `npm/`, `docs/`, `skills/`),
  shared `VERSION` + `scripts/sync-version.sh`, MIT license, release CI.
- **gem** foundation: `Clowk::Phlex` module + `Component` base (thin Phlex::HTML
  with `tokens` + vendored `icon` helper), `Charts::Format`, `Charts::WebTime`,
  design tokens (`styles/clowk-phlex.css`, `--clowk-*`, dark+light + @theme).
- **gem** charts — full Ruby component set, renders standalone (no Rails):
  `Charts::{TimeSeries, GaugeRadial, GaugeLinear, Sparkline, ChartShape, Card,
  NumberCard, RangePicker, IntervalPicker, TypePicker, DisplaySettings}` and
  `UI::{Switch, Icons}`. Pickers take an injected `base_path` (no host routes).
  RSpec suite: 24 examples.
- **npm** `@clowk/phlex`: Stimulus controllers (metrics-chart, metrics-display,
  metrics-display-settings, metrics-section, time-range-filter, panel-options,
  number-card, dropdown, popover) + `registerClowkPhlex(application)`. Shared
  storage namespaced under one prefix (`chart_storage`).
- **build**: `dist/clowk-phlex.css` precompiled by scanning the gem's Phlex
  components across the monorepo — consumers need no Tailwind `@source`. JS
  bundled with esbuild (Stimulus / Turbo / sortablejs kept external).
- **docs**: `docs/API.md` — component catalog + the host-owns-containers contract.
- **npm tests**: Vitest (jsdom) unit suite — lib helpers (storage, chart_storage,
  panel_prefs) + Stimulus controllers (dropdown, metrics-section, panel-options,
  number-card, metrics-display, metrics-display-settings) mounted in a real
  Stimulus app. 22 tests. CI runs build → smoke → vitest.
- **gem lint**: StandardRB (`.standard.yml`, rake default = spec + standard),
  plus a `.rubocop.yml` that defers a stray editor RuboCop to Standard's rules.
- `GaugeLinear` multi gains a breakdown variant (`dot`, `threshold`, `title`,
  `total_label`) for cost/usage bars; the settings drawer resets per-card resize
  spans when a column count is picked so the choice always applies.

[Unreleased]: https://github.com/thadeu/clowk-phlex/compare/v0.1.2...HEAD
[0.1.2]: https://github.com/thadeu/clowk-phlex/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/thadeu/clowk-phlex/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/thadeu/clowk-phlex/releases/tag/v0.1.0
