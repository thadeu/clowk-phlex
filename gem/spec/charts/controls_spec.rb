# frozen_string_literal: true

RSpec.describe "Dashboard controls" do
  describe Clowk::Phlex::Charts::RangePicker do
    it "renders preset pills + custom chip, host base_path injected" do
      html = described_class.new(range: "7d", base_path: "/metrics", extra_params: { interval: "1m" }).call

      expect(html).to include('data-controller="time-range-filter"')
      expect(html).to include('action="/metrics"')
      expect(html).to include(">7d<")
      expect(html).to include('viewBox="0 0 24 24"') # calendar icon
    end
  end

  describe Clowk::Phlex::Charts::IntervalPicker do
    it "renders an interval dropdown carrying extra params in row URLs" do
      html = described_class.new(current: "auto", base_path: "/metrics", extra_params: { range: "1h" }).call

      expect(html).to include('data-controller="dropdown"')
      expect(html).to include("every")
      expect(html).to include("/metrics?")
      expect(html).to include("range=1h")
    end
  end

  describe Clowk::Phlex::Charts::TypePicker do
    it "renders the chart-type dropdown with ChartShape glyphs" do
      html = described_class.new(current: "area", base_path: "/metrics").call

      expect(html).to include('data-controller="dropdown"')
      expect(html).to include("<svg")     # ChartShape glyph
      expect(html).to include("Radial")   # from ChartShape::LABELS
    end
  end

  describe Clowk::Phlex::Charts::DisplaySettings do
    it "renders visibility tiles + columns picker + Update, keyed by kind" do
      html = described_class.new(kind: "metrics", items: [
        { metric: "host_cpu", label: "HOST · CPU", color: "#5B8DEF", unit: "%", default_visible: true },
        { metric: "host_mem", label: "HOST · MEM", color: "#3FD08C", unit: "%", default_visible: true }
      ]).call

      expect(html).to include('data-controller="metrics-display-settings"')
      expect(html).to include('data-metrics-display-settings-kind-value="metrics"')
      expect(html).to include("HOST · CPU")
      expect(html).to include("Columns")
      expect(html).to include("Update")
    end
  end
end
