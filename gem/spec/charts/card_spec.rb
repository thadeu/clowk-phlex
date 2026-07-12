# frozen_string_literal: true

RSpec.describe "Chart assemblies" do
  def points(n = 24)
    anchor = Time.utc(2026, 7, 10, 12, 0, 0)

    (0...n).map do |i|
      v = [(10 + 8 * Math.sin(i * 0.4)).round(2), 0].max

      {ts: (anchor - (n - 1 - i) * 3600).iso8601, value: v, formatted: v.to_s}
    end
  end

  describe Clowk::Phlex::Charts::Card do
    it "renders a single-series area card with headline + min/avg/max footer" do
      html = described_class.new(
        label: "HOST · CPU", color: "#5B8DEF", unit: "%", chart_type: "area",
        points: points, range_ms: 86_400_000
      ).call

      expect(html).to include("HOST · CPU")
      expect(html).to include("<svg")
      expect(html).to include("min ")
      expect(html).to include("avg ")
    end

    it "shows a maximize button when expand_url is given (vendored icon)" do
      html = described_class.new(
        label: "CPU", color: "#5B8DEF", unit: "%", chart_type: "area",
        points: points, range_ms: 86_400_000, expand_url: "/metrics/chart?metric=host_cpu"
      ).call

      expect(html).to include("/metrics/chart?metric=host_cpu")
      expect(html).to include('viewBox="0 0 24 24"')   # icon rendered
    end

    it "renders a radial gauge card" do
      html = described_class.new(
        label: "DISK", color: "#E8934B", unit: "GB", chart_type: "gauge_radial",
        capacity_label: "42 GB", capacity_pct: 50, current: 20.9, points: points, range_ms: 86_400_000
      ).call

      expect(html).to include("50%")
      expect(html).to include("stroke-dasharray")
    end

    it "renders a stacked multi linear gauge from gauge_bars" do
      html = described_class.new(
        label: "PODS · MEM", color: "#5B8DEF", unit: "GB", chart_type: "gauge_linear",
        range_ms: 86_400_000,
        gauge_bars: [
          {label: "api", pct: 46, value_label: "3.7 GB", capacity_label: "8 GB", color: "#5B8DEF"},
          {label: "jobs", pct: 93, value_label: "7.4 GB", capacity_label: "8 GB", color: "#E8B24B"}
        ]
      ).call

      expect(html).to include("2 pods")
      expect(html).to include("var(--clowk-red)")
    end

    it "omits resize handles when resizable: false" do
      html = described_class.new(
        label: "CPU", color: "#5B8DEF", unit: "%", chart_type: "area", metric: "cpu",
        points: points, range_ms: 86_400_000, resizable: false
      ).call

      expect(html).not_to include("startResize")
    end
  end

  describe Clowk::Phlex::Charts::NumberCard do
    it "renders a single big number with a timeline" do
      html = described_class.new(
        label: "FS · INVITE", color: "#5B8DEF", formatted: "1,284", range: "7d",
        metric: "fs_invite", range_ms: 86_400_000, sub: "count · sip_method", series: points
      ).call

      expect(html).to include("1,284")
      expect(html).to include("count · sip_method")
    end

    it "renders a multi-pod number row over a shared timeline" do
      html = described_class.new(
        label: "3 PODS · REQ", color: "#3FD08C", formatted: "—", range: "7d", metric: "pods_req",
        range_ms: 86_400_000,
        numbers: [
          {label: "api", color: "#5B8DEF", formatted: "842", value: 842},
          {label: "jobs", color: "#B36CF6", formatted: "391", value: 391}
        ],
        series: [
          {label: "api", color: "#5B8DEF", points: points},
          {label: "jobs", color: "#B36CF6", points: points}
        ]
      ).call

      expect(html).to include("842")
      expect(html).to include("391")
    end
  end
end
