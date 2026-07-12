# frozen_string_literal: true

require "time"
require "json"
require "digest"
require "phlex"
require "active_support/core_ext/object/blank"
require "active_support/core_ext/object/to_query"

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

# UI atoms
require_relative "phlex/ui/icons"
require_relative "phlex/ui/switch"

# Chart primitives
require_relative "phlex/charts/chart_shape"
require_relative "phlex/charts/sparkline"
require_relative "phlex/charts/gauge_radial"
require_relative "phlex/charts/gauge_linear"
require_relative "phlex/charts/time_series"

# Chart assemblies (compose the primitives above)
require_relative "phlex/charts/card"
require_relative "phlex/charts/number_card"

# Dashboard controls (host injects the URLs / base paths)
require_relative "phlex/charts/range_picker"
require_relative "phlex/charts/interval_picker"
require_relative "phlex/charts/type_picker"
require_relative "phlex/charts/display_settings"
