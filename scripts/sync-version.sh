#!/usr/bin/env bash
# Propagate the repo-root /VERSION into both packages so a release publishes with
# the right version. Run in dev after bumping VERSION, and in the release CI
# after it writes VERSION from the pushed tag.
#
#   - gem: bakes a static literal into gem/lib/clowk/phlex/version.rb (that file
#     ships in the .gem, so Clowk::Phlex::VERSION is correct once installed).
#   - npm: sets the version field in npm/package.json (npm publish reads it).
set -euo pipefail

cd "$(dirname "$0")/.."

VERSION="$(tr -d '[:space:]' < VERSION)"

if [ -z "$VERSION" ]; then
  echo "sync-version: /VERSION is empty" >&2
  exit 1
fi

cat > gem/lib/clowk/phlex/version.rb <<RUBY
# frozen_string_literal: true

# Synced from the repo-root /VERSION by scripts/sync-version.sh (dev + release CI).
# The gem and the @clowk/phlex npm package share this version — do not edit by
# hand; bump /VERSION and re-run the script.
module Clowk
  module Phlex
    VERSION = "${VERSION}"
  end
end
RUBY

(cd npm && npm pkg set "version=${VERSION}" >/dev/null)

echo "synced version → ${VERSION} (gem/version.rb + npm/package.json)"
