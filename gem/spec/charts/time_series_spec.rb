# frozen_string_literal: true

RSpec.describe Clowk::Phlex::Charts::TimeSeries do
  # Deterministic sample points (fixed anchor → no Time.now).
  def points(n = 24)
    anchor = Time.utc(2026, 7, 10, 12, 0, 0)

    (0...n).map do |i|
      v = [(10 + 8 * Math.sin(i * 0.4)).round(2), 0].max

      { ts: (anchor - (n - 1 - i) * 3600).iso8601, value: v, formatted: v.to_s }
    end
  end

  it "renders a single-series area chart as SVG driven by the metrics-chart controller" do
    html = described_class.new(
      points: points, color: "#5B8DEF", unit: "%", label: "CPU", range_ms: 86_400_000
    ).call

    expect(html).to include("<svg")
    expect(html).to include('data-controller="metrics-chart"')
    expect(html).to include('data-metrics-chart-target="area"')
  end

  it "uses clowk design tokens (not voodu)" do
    html = described_class.new(
      points: points, color: "#5B8DEF", unit: "%", label: "CPU", range_ms: 86_400_000
    ).call

    expect(html).to include("var(--clowk-border)")
    expect(html).to include("var(--clowk-font-mono")
    expect(html).not_to include("voodu")
  end

  it "renders multi-series grouped bars, one indexed rect per series" do
    series = [
      { label: "api", color: "#5B8DEF", points: points },
      { label: "jobs", color: "#F0619A", points: points }
    ]

    html = described_class.new(
      points: [], series: series, color: "#5B8DEF", unit: "", label: "REQ",
      range_ms: 86_400_000, style: :bars
    ).call

    expect(html.scan('data-metrics-chart-target="bar"').size).to be > 20
    expect(html).to include('data-series-index="1"')
  end

  it "renders an interactive legend for multi-series (toggle + highlight)" do
    series = [{ label: "api", color: "#5B8DEF", current: 0.18, points: points }]

    html = described_class.new(
      points: [], series: series, color: "#5B8DEF", unit: "%", label: "CPU", range_ms: 86_400_000
    ).call

    expect(html).to include('data-metrics-chart-target="legendItem"')
    expect(html).to include("toggleSeries")
  end

  it "formats sub-1% values honestly via Charts::Format" do
    expect(Clowk::Phlex::Charts::Format.percent(0.05)).to eq("0.05%")
    expect(Clowk::Phlex::Charts::Format.number(0)).to eq("0")
  end
end
