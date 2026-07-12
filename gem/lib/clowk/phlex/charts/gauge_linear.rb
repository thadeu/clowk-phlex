# frozen_string_literal: true

# Components::UI::GaugeLinear — horizontal capacity bar for a capacity / percent
# metric (ported from voodu Metrics::GaugeLinear): a big % up top, a filled
# track, and used / total figures underneath. The fill tints AMBER past 70% and
# RED past 90% (same thresholds as GaugeRadial).
#
#   percent: true  → headline reads the fill "%".
#   percent: false → headline reads center_value (raw count) instead.
#
# MULTI mode — pass `bars: [{label:, pct:, value_label:, capacity_label:, color:}]`
# to stack one labeled capacity bar per row (e.g. one per pod). Each row shows
# label + value on top, a fill bar, and (when `capacity_label` is given) a
# pct / total line underneath. Multi options:
#
#   dot:         true  → a colored square before each label (breakdown style)
#   threshold:   false → keep each bar its own color (no amber>70 / red>90 tint)
#   title:       "…"   → a section header row (uppercase label)
#   total_label: "…"   → a "Total <x>" figure shown at the right of the header
#
# The defaults (dot: false, threshold: true) give the capacity-gauge look; a
# simple cost/usage breakdown is `dot: true, threshold: false` with a title +
# total and value_label-only rows (no capacity_label → no bottom line).
class Clowk::Phlex::Charts::GaugeLinear < Clowk::Phlex::Component
  def initialize(pct: nil, color: "#5B8DEF", value_label: nil, capacity_label: nil, percent: true, center_value: nil,
    bars: nil, dot: false, threshold: true, title: nil, total_label: nil)
    @pct = clamp(pct.to_f) if pct
    @color = color
    @value_label = value_label
    @capacity_label = capacity_label
    @percent = percent
    @center_value = center_value
    @bars = bars.is_a?(Array) ? bars : nil
    @dot = dot
    @threshold = threshold
    @title = title
    @total_label = total_label
  end

  def multi? = !@bars.nil? && @bars.any?

  def view_template
    return multi_template if multi?

    div(class: "flex flex-col justify-center gap-3 py-4 min-h-[120px]") do
      span(class: "font-clowk-mono text-[26px] font-semibold text-clowk-text leading-none") { headline }

      div(class: "h-3.5 w-full bg-clowk-surface-3 overflow-hidden rounded-clowk-sm") do
        div(style: "width: #{@pct.round(1)}%; height: 100%; background: #{fill_color};")
      end

      if @value_label.present? || @capacity_label.present?
        div(class: "flex items-center justify-between font-clowk-mono text-[11px] text-clowk-muted") do
          span { @value_label.to_s.presence || "—" }
          span { @capacity_label.to_s.presence || "" }
        end
      end
    end
  end

  private

  # multi_template — an optional header (title + total) over N stacked bars.
  def multi_template
    div(class: "flex flex-col gap-3 #{"justify-center py-3 min-h-[120px]" unless @title}") do
      multi_header if @title
      @bars.each { |b| gauge_row(b) }
    end
  end

  def multi_header
    div(class: "flex items-center justify-between") do
      span(class: "text-[11px] font-semibold uppercase tracking-[0.05em] text-clowk-muted") { @title }

      if @total_label
        span(class: "text-[12px] text-clowk-muted") do
          plain "Total "
          span(class: "font-clowk-mono text-clowk-amber") { @total_label }
        end
      end
    end
  end

  def gauge_row(bar)
    pct = clamp(bar[:pct].to_f)
    base = bar[:color] || @color
    fill = @threshold ? row_fill_color(pct, base) : base

    div(class: "flex flex-col gap-1.5") do
      div(class: "flex items-baseline justify-between gap-2") do
        span(class: "flex items-center gap-2 min-w-0 font-clowk-mono text-[11.5px] text-clowk-text-2 truncate") do
          span(class: "w-2 h-2 rounded-[2px] shrink-0", style: "background: #{base};") if @dot
          span(class: "truncate") { bar[:label].to_s }
        end
        span(class: "font-clowk-mono text-[11.5px] font-semibold text-clowk-text shrink-0") { bar[:value_label].to_s.presence || pct_string(pct) }
      end

      div(class: "h-2.5 w-full bg-clowk-surface-3 overflow-hidden rounded-full") do
        div(class: "h-full rounded-full", style: "width: #{pct.round(1)}%; background: #{fill};")
      end

      if bar[:capacity_label].present?
        div(class: "flex items-center justify-between font-clowk-mono text-[10px] text-clowk-muted-2") do
          span { pct_string(pct) }
          span { bar[:capacity_label].to_s }
        end
      end
    end
  end

  def row_fill_color(pct, color)
    return "var(--clowk-red)" if pct >= 90
    return "var(--clowk-amber)" if pct >= 70

    color
  end

  def pct_string(pct)
    (pct < 10) ? "#{"%.1f" % pct}%" : "#{pct.round}%"
  end

  def fill_color
    return "var(--clowk-red)" if @pct >= 90
    return "var(--clowk-amber)" if @pct >= 70

    @color
  end

  def headline
    (!@percent && @center_value.to_s.present?) ? @center_value.to_s : pct_label
  end

  def pct_label
    (@pct < 10) ? "#{"%.1f" % @pct}%" : "#{@pct.round}%"
  end

  def clamp(v)
    return 0.0 if v.negative?
    return 100.0 if v > 100

    v
  end
end
