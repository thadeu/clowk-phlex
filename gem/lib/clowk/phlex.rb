# frozen_string_literal: true

require "time"
require "json"
require "digest"
require "phlex"
require "active_support/core_ext/object/blank"

module Clowk
  # Clowk::Phlex — the UI component library namespace. `include Clowk::Phlex` in a
  # view to get the short names (`Charts::Card`, `UI::Dropdown`) via ancestor
  # constant lookup; the `Charts::` / `UI::` prefix is kept on purpose so nothing
  # collides with the host app's own `Card` / `Button`.
  module Phlex
    module Charts; end
    module UI; end
  end
end

require_relative "phlex/version"
require_relative "phlex/component"
require_relative "phlex/charts/format"
require_relative "phlex/charts/web_time"
require_relative "phlex/charts/time_series"
