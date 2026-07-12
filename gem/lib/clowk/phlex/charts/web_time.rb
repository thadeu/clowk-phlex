# frozen_string_literal: true

module Clowk
  module Phlex
    module Charts
      # WebTime — the single "render this moment in the app's timezone" seam for
      # the chart x-axis + tooltips. Uses ActiveSupport's Time.zone when present
      # (Rails hosts), else falls back to UTC — so the lib works with or without
      # Rails, and a host can retune the zone in one place later.
      module WebTime
        module_function

        DEFAULT_ZONE_NAME = "UTC"

        def zone_name
          (defined?(Time.zone) && Time.zone&.name) || DEFAULT_ZONE_NAME
        rescue StandardError
          DEFAULT_ZONE_NAME
        end

        # strftime — format a moment (Time / TimeWithZone). Never raises: returns
        # nil on bad input so views render "—" instead of 500-ing.
        def strftime(time, pattern)
          time&.strftime(pattern)
        rescue StandardError
          nil
        end
      end
    end
  end
end
