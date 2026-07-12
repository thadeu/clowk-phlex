# frozen_string_literal: true

module Clowk
  module Phlex
    # Component is the root Phlex class every clowk-phlex component inherits from.
    # Kept intentionally thin so the lib renders standalone (no Rails required for
    # the pure-view components). Rails view helpers (routes, form_with) are mixed
    # into the specific components that need them, not forced on every subclass.
    #
    # NOTE: `::Phlex::HTML` is fully qualified — inside `Clowk`, the bare `Phlex`
    # would resolve to `Clowk::Phlex`, not the phlex gem.
    class Component < ::Phlex::HTML
      private

      # icon — render a vendored Heroicon (outline) by name. Replaces the
      # PhlexIcons dependency; extra attrs (class:, aria, …) flow to the <svg>.
      #
      #   icon(:ellipsis_vertical, class: "w-4 h-4")
      def icon(name, **attrs)
        d = Clowk::Phlex::UI::Icons::PATHS.fetch(name.to_sym) do
          raise ArgumentError, "unknown clowk icon: #{name.inspect}"
        end

        svg(
          xmlns: "http://www.w3.org/2000/svg", fill: "none", viewBox: "0 0 24 24",
          "stroke-width": "1.5", stroke: "currentColor", "aria-hidden": "true", **attrs
        ) { |s| s.path("stroke-linecap": "round", "stroke-linejoin": "round", d: d) }
      end

      # tokens — merge CSS class strings, dropping nil / false / empty, so call
      # sites can write `tokens("px-3", active && "bg-clowk-accent-dim")` without
      # the compact+join dance.
      def tokens(*classes)
        classes.flatten.compact.reject { |c| c == false || c == "" }.join(" ").squeeze(" ").strip
      end
    end
  end
end
