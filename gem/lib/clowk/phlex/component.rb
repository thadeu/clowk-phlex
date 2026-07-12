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

      # tokens — merge CSS class strings, dropping nil / false / empty, so call
      # sites can write `tokens("px-3", active && "bg-clowk-accent-dim")` without
      # the compact+join dance.
      def tokens(*classes)
        classes.flatten.compact.reject { |c| c == false || c == "" }.join(" ").squeeze(" ").strip
      end
    end
  end
end
