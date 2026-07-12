# frozen_string_literal: true

require_relative "lib/clowk/phlex/version"

Gem::Specification.new do |spec|
  spec.name = "clowk-phlex"
  spec.version = Clowk::Phlex::VERSION
  spec.authors = ["Thadeu Esteves"]
  spec.email = ["tadeuu@gmail.com"]

  spec.summary = "Phlex UI components with Stimulus behaviors — charts first."
  spec.description = "The Ruby half of clowk-phlex: Phlex view components " \
                     "(charts, gauges, pickers) that render SVG/HTML markup + " \
                     "data-* attributes. Behavior and styles ship via the " \
                     "companion @clowk/phlex npm package."
  spec.homepage = "https://github.com/clowk/clowk-phlex"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Ship the Ruby components + the token stylesheet. Build output (npm dist) and
  # tests are excluded.
  spec.files = Dir["lib/**/*.rb", "styles/**/*.css"]
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 7.0"
  spec.add_dependency "phlex", "~> 2.0"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.13"
  spec.add_development_dependency "standard", "~> 1.0"
end
