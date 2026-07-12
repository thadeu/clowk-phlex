# Changelog

All notable changes to this project are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
The `clowk-phlex` gem and the `@clowk/phlex` npm package share this version.

## [Unreleased]

### Added
- Repository scaffold: monorepo layout (`gem/`, `npm/`, `docs/`, `skills/`),
  shared `VERSION`, MIT license, release CI skeleton.
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

[Unreleased]: https://github.com/clowk/clowk-phlex/commits/main
