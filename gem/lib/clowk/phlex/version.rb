# frozen_string_literal: true

module Clowk
  module Phlex
    # VERSION is sourced from the repo-root /VERSION file (single source of truth
    # shared with the @clowk/phlex npm package). In a packaged gem that file may
    # not ship, so the release build bakes the value in; dev reads it live.
    VERSION = begin
      root = File.expand_path("../../../..", __dir__)
      File.read(File.join(root, "VERSION")).strip
    rescue Errno::ENOENT
      "0.0.0"
    end
  end
end
