# Contributing to clowk-phlex

## Layout

Two publishable artifacts in one repo, with **zero code-load coupling** — Ruby
never `require`s JS and JS never reads Ruby; they meet only at runtime via
`data-*` attributes.

```
gem/    # clowk-phlex (RubyGems)  — lib/clowk/phlex/**  + styles/clowk-phlex.css (token source)
npm/    # @clowk/phlex (npm)      — src/** (controllers, turbo_actions, lib) + build/ + dist/ (gitignored)
docs/   # API.md, design decisions
skills/ # Agent Skill (skills/clowk-phlex/…)
VERSION # single source of truth read by both manifests
```

## Prerequisites

Versions are pinned in [`.tool-versions`](.tool-versions) (asdf / mise):

```bash
mise install        # or: asdf install
```

## Working on the gem

```bash
cd gem
bundle install
bundle exec rake          # rspec + standardrb
bundle exec standardrb --fix   # auto-format
```

Ruby is linted with [StandardRB](https://github.com/standardrb/standard); the
release CI gates on it, so keep `bundle exec standardrb` clean.

Components are Phlex classes under `Clowk::Phlex::{Charts,UI}`. They emit static
utility classes (`bg-clowk-surface`, …) — never build class names by
interpolation, or the CSS precompile can't find them. Truly dynamic values
(series colors, gauge widths) go through inline `style:`.

## Working on the npm package

```bash
cd npm
pnpm install
pnpm build      # bundles JS + precompiles clowk-phlex.css into dist/
pnpm smoke      # post-build sanity check on dist/
pnpm test       # vitest unit tests (jsdom) — controllers + lib helpers
```

### The CSS precompile

`npm/build/` runs Tailwind v4 against **`../gem/lib/**/*.rb`** (that's why this
is a monorepo — the build needs to see the Ruby components) and emits
`dist/clowk-phlex.css`. The utilities reference `var(--color-clowk-*)`, and the
tokens ship in the same file, so consumers get a themeable, self-contained
stylesheet with **no Tailwind `@source` required on their end**.

## Versioning

`/VERSION` is the single source of truth. Bump it, then run
`./scripts/sync-version.sh` to propagate it into `gem/lib/clowk/phlex/version.rb`
(a static literal that ships in the gem) and `npm/package.json`. The release CI
runs the same script from the pushed tag, so the gem and npm package always
publish with matching versions.

## Releasing

`dist/` is never committed — the CI builds it:

1. Bump `/VERSION`, update `CHANGELOG.md`.
2. Tag `vX.Y.Z` and push.
3. [`.github/workflows/release.yml`](.github/workflows/release.yml) builds
   `dist/`, runs the gem + npm tests, publishes to RubyGems + npm, and attaches
   the packaged artifacts (`.gem` + npm tarball) to the GitHub release.

## Conventions

- **Ruby = view only.** No DB, no business logic, no host routes. Inject paths /
  URLs as kwargs.
- **Behavior = JS**, attached via `data-controller` / `data-*`. A component must
  render statically (SSR) and gain interactivity when `@clowk/phlex` registers.
- **Containers = the host's job.** No modal / drawer shells here — expose content
  + events; the app wraps them.
- **Tokens = `--color-clowk-*`.** Theme by overriding the CSS variables.
