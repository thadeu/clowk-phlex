# frozen_string_literal: true

RSpec.describe "Chart primitives" do
  describe Clowk::Phlex::Charts::GaugeRadial do
    it "renders a semicircle arc that fills to the percent" do
      html = described_class.new(pct: 63, color: "#5B8DEF", sub_label: "13.2 / 21 GB").call

      expect(html).to include("<svg")
      expect(html).to include("stroke-dasharray")
      expect(html).to include("63%")
    end

    it "tints red past 90%" do
      html = described_class.new(pct: 93, color: "#5B8DEF").call

      expect(html).to include("var(--clowk-red)")
    end
  end

  describe Clowk::Phlex::Charts::GaugeLinear do
    it "renders a single capacity bar with a headline percent" do
      html = described_class.new(pct: 68, color: "#B36CF6", value_label: "28.6 GB", capacity_label: "42.0 GB").call

      expect(html).to include("68%")
      expect(html).to include("bg-clowk-surface-3")
    end

    it "stacks N bars in multi mode, amber past 70% / red past 90%" do
      html = described_class.new(bars: [
        { label: "api", pct: 46, value_label: "3.7 GB", capacity_label: "8 GB", color: "#5B8DEF" },
        { label: "jobs", pct: 93, value_label: "7.4 GB", capacity_label: "8 GB", color: "#E8B24B" }
      ]).call

      expect(html).to include("api")
      expect(html).to include("var(--clowk-red)")   # jobs at 93%
      expect(html).to include("46%")
    end
  end

  describe Clowk::Phlex::Charts::Sparkline do
    it "renders an inline area+line sparkline" do
      html = described_class.new(points: [1, 4, 2, 8, 5, 9, 3], color: "#3FD08C").call

      expect(html).to include("<svg")
      expect(html).to include('data-controller="sparkline-tooltip"')
    end
  end

  describe Clowk::Phlex::Charts::ChartShape do
    it "renders the glyph for each chart type" do
      %w[area bars line gauge_radial gauge_linear].each do |type|
        expect(described_class.new(type: type).call).to include("<svg")
      end
    end

    it "exposes the canonical type list" do
      expect(described_class::METRIC_TYPES.map { |t| t[:value] }).to include("area", "bars", "line")
    end
  end

  describe Clowk::Phlex::UI::Switch do
    it "renders a checkbox-backed toggle" do
      html = described_class.new(checked: true).call

      expect(html).to include("type=\"checkbox\"")
      expect(html).to include("peer-checked:bg-clowk-accent")
    end
  end
end
