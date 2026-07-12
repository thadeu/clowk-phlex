# CLAUDE.md — clowk-phlex

This file guides Claude Code sessions working in this repository.

## What this is

`clowk-phlex` is a **dual-artifact** UI component library:

- **gem `clowk-phlex`** (RubyGems) — Phlex view components that render SVG/HTML
  markup + `data-*` attributes. **VIEW ONLY.**
- **npm `@clowk/phlex`** — Stimulus controllers + Turbo actions + a precompiled
  `clowk-phlex.css`. **BEHAVIOR + STYLES.**

They are two halves of ONE library, version-locked. Ruby renders markup; JS
gives it behavior; they meet only at runtime through `data-*` attributes — there
is no code-load coupling between the two sides.

**Charts** is the first module (area / line / bars single & multi-series, radial
& linear gauges, number tiles, sparklines + range/interval pickers, settings
panel, resize, interactive legends, hover, maximize hook). UI primitives
(Button, Drawer, Sidebar, Dropdown, Table…) migrate in later under the same
`Clowk::Phlex::UI` namespace.

The library was extracted from the `dialive` app (`~/code/dialive/apps/web`),
where the components were first built and hardened — that app is the reference
implementation and the integration test.

## Golden rules

1. **Ruby is view-only.** No DB, no business logic, no host routes. Components
   take plain data (hashes / kwargs). URLs/paths are injected by the host.
2. **Behavior lives in JS**, attached via `data-controller` / `data-*`. Every
   component must render statically (SSR) and gain interactivity only once
   `@clowk/phlex` is registered.
3. **Containers are the host's job.** No modal / drawer shells in the lib —
   components expose content + events (e.g. a maximize button dispatches an
   event); the app wraps them in its own modal / drawer.
4. **One version.** `/VERSION` is the single source of truth; the gemspec and
   `package.json` both read from it.
5. **Tokens are `--color-clowk-*`.** Consumers theme by overriding the CSS
   variables. The shipped CSS is **precompiled** (the npm build scans
   `gem/lib/**/*.rb`), so consumers need NO Tailwind `@source`. Tailwind v4 is
   optional for them — only needed to extend via the `class:` passthrough.
6. **Static classes only.** Never build utility class names by interpolation, or
   the CSS precompile can't find them. Dynamic values (series colors, gauge
   widths) go through inline `style:`.

## Layout

```
gem/      # Ruby gem — lib/clowk/phlex/{component,charts/*,ui/*,format}.rb
          #            styles/clowk-phlex.css (token @theme + @source; build input)
npm/      # npm package — src/{controllers,turbo_actions,lib}/*.js, index.js
          #               build/ (tailwind precompile) → dist/ (gitignored)
docs/     # API.md + design decisions
skills/   # Agent Skill: skills/clowk-phlex/SKILL.md (for `npx skills add`)
VERSION LICENSE README CONTRIBUTING CHANGELOG   # root
.github/workflows/release.yml                    # tag v* → build + publish + release
```

`dist/` is never committed — CI builds it on release.

## Commands (once the packages are filled in)

```bash
# gem
cd gem && bundle install && bundle exec rspec

# npm
cd npm && pnpm install && pnpm build && pnpm test
#   pnpm build bundles the JS AND precompiles ../gem/lib/**/*.rb → dist/clowk-phlex.css
```

## Release

Tag `vX.Y.Z` → GitHub Actions syncs `VERSION`, builds `dist/`, runs both test
suites, publishes the gem to RubyGems + the package to npm, and attaches the
packaged `.gem` and npm tarball to the GitHub release.

## Ergonomics

- `include Clowk::Phlex` in a view → short names `Charts::Card`, `UI::Dropdown`
  (constant lookup via ancestors). The `Charts::` / `UI::` prefix is kept on
  purpose so nothing collides with the host app's own `Card` / `Button`.
- Public API surface = component initializers (kwargs) + slots + `Format`
  helpers. Internal render methods are NOT a stable contract.
