# frozen_string_literal: true

# Views::Metrics::DisplaySettings — the "Settings" drawer body for the chart
# grid. A flat, domain-agnostic tile per card (portable → gem): click a tile to
# toggle its visibility, drag the grip to reorder, pick the column count. The
# "Update" button commits { hidden, order, cols } to the shared display store
# and fires `metrics-display:changed`; the grid re-applies live.
#
# `items` — [{ metric:, label:, color:, unit:, default_visible: }] for every
# manageable card on the page (those carrying a metric key).
class Clowk::Phlex::Charts::DisplaySettings < Clowk::Phlex::Component
  def initialize(kind:, items:)
    @kind = kind
    @items = items
  end

  def view_template
    return if @items.empty?

    div(
      class: "p-4 flex flex-col gap-4 @container",
      data: {
        controller: "metrics-display-settings",
        metrics_display_settings_kind_value: @kind
      }
    ) do
      header_row
      hint_row
      columns_picker
      cards_grid
    end
  end

  private

  def header_row
    div(class: "flex items-center gap-2.5") do
      span(class: "text-[10.5px] font-semibold uppercase tracking-[0.08em] font-clowk-mono text-clowk-muted shrink-0") { "Charts" }
      span(class: "flex-1 h-px bg-clowk-border")
      button(
        type: "button",
        data: {action: "click->metrics-display-settings#save", role: "update-btn"},
        class: "inline-flex items-center gap-1.5 px-3 h-7 border border-clowk-border bg-clowk-surface " \
               "text-clowk-text-2 text-[11.5px] font-medium hover:bg-clowk-surface-2 hover:text-clowk-text transition-colors shrink-0"
      ) { "Update" }
    end
  end

  def hint_row
    p(class: "text-[11px] text-clowk-muted-2 leading-relaxed") do
      plain "Click to toggle visibility. Drag "
      span(class: "inline-flex align-middle text-clowk-muted-2 mx-0.5") { icon(:bars_3, class: "w-3 h-3 inline") }
      plain " to reorder. Press "
      span(class: "font-semibold text-clowk-text-2") { "Update" }
      plain " to apply."
    end
  end

  def columns_picker
    div(class: "flex flex-wrap items-center gap-x-2.5 gap-y-1.5") do
      span(class: "text-[10.5px] font-semibold uppercase tracking-[0.08em] font-clowk-mono text-clowk-muted shrink-0") { "Columns" }
      span(class: "text-[10px] text-clowk-muted-2") { "(applies when 3+ visible)" }
      div(class: "ml-auto inline-flex items-center gap-1") do
        [1, 2, 3, 4].each { |n| cols_pill(n) }
      end
    end
  end

  def cols_pill(n)
    button(
      type: "button",
      data: {action: "click->metrics-display-settings#selectCols", cols: n.to_s, metrics_display_settings_target: "colsBtn"},
      class: "inline-flex items-center justify-center w-8 h-7 border border-clowk-border bg-clowk-surface " \
             "text-clowk-text-2 text-[11.5px] font-clowk-mono font-medium hover:bg-clowk-surface-2 hover:text-clowk-text transition-colors"
    ) { n.to_s }
  end

  def cards_grid
    div(
      data: {metrics_display_settings_target: "grid"},
      class: "grid grid-cols-2 @sm:grid-cols-3 gap-2"
    ) do
      @items.each { |item| card_tile(item) }
    end
  end

  def card_tile(spec)
    div(
      data: {
        metrics_display_settings_target: "card",
        metric: spec[:metric],
        default_visible: (spec[:default_visible] == false) ? "false" : "true",
        action: "click->metrics-display-settings#toggle"
      },
      class: "relative flex flex-col gap-1.5 p-2.5 cursor-pointer select-none border border-clowk-border " \
             "bg-clowk-surface-2 hover:bg-clowk-surface transition-colors"
    ) do
      div(class: "flex items-center gap-1.5") do
        span(
          data: {role: "drag-handle"},
          class: "cursor-grab active:cursor-grabbing text-clowk-muted-2 hover:text-clowk-text shrink-0",
          title: "Drag to reorder"
        ) { icon(:bars_3, class: "w-3 h-3 pointer-events-none") }

        span(class: "inline-block w-2 h-2 rounded-full shrink-0", style: "background: #{spec[:color]};")

        span(data: {role: "check"}, class: "ml-auto text-clowk-accent-2") do
          icon(:check, class: "w-3 h-3")
        end
      end

      span(class: "text-[11px] font-semibold font-clowk-mono text-clowk-text truncate leading-tight") { spec[:label] }

      if spec[:unit].present?
        span(class: "text-[10px] font-clowk-mono text-clowk-muted-2 leading-tight") { spec[:unit] }
      else
        span(class: "text-[10px] leading-tight invisible") { "·" }
      end
    end
  end
end
