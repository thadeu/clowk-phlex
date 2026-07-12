# frozen_string_literal: true

module Clowk
  module Phlex
    module Charts
      # Format — magnitude-adaptive decimal formatting for chart labels, headline
      # values and tooltips (ex-MetricFormat). A flat "%.1f" floors sub-0.1 values
      # to "0.0", which makes an idle series read as zero even when the curve
      # clearly moves — the shape is right but every number lies. These tiers keep
      # enough precision for the magnitude you're looking at.
      #
      #   >= 100  → 0 decimals    ("142")
      #   >= 10   → 1 decimal     ("42.5")
      #   >= 1    → 1 decimal     ("4.2")
      #   >= 0.01 → 2 decimals    ("0.05")
      #   > 0     → "<0.01"
      #   = 0     → "0"
      module Format
        module_function

        def number(v)
          return "—" if v.nil?
          return "0" if v.zero?

          abs = v.abs
          return v.round.to_s if abs >= 100
          return v.round(1).to_s if abs >= 10
          return v.round(1).to_s if abs >= 1
          return v.round(2).to_s if abs >= 0.01

          "<0.01"
        end

        def percent(v)
          return "—" if v.nil?
          return "0%" if v.zero?

          abs = v.abs
          return "#{v.round}%" if abs >= 100
          return format("%.1f%%", v) if abs >= 1
          return format("%.2f%%", v) if abs >= 0.01

          "<0.01%"
        end
      end
    end
  end
end
