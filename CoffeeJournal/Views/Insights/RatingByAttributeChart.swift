import SwiftUI
import Charts

struct RatingByAttributeChart: View {
    let dataPoints: [ChartDataPoint]
    let title: String
    var accentColor: Color = .appAccent

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(Constants.Typography.micro)
                .foregroundStyle(Color.textTertiary)
                .tracking(0.3)
                .textCase(.uppercase)

            Chart(dataPoints) { point in
                BarMark(
                    x: .value("Rating", point.value),
                    y: .value("Label", point.label)
                )
                .foregroundStyle(accentColor)
                .cornerRadius(2)
                .annotation(position: .trailing, alignment: .leading, spacing: 6) {
                    Text(String(format: "%.1f", point.value))
                        .font(Constants.Typography.mono)
                        .foregroundStyle(Color.textTertiary)
                }
            }
            .chartXScale(domain: 0...5)
            .chartXAxis {
                AxisMarks(values: [1, 2, 3, 4, 5]) {
                    AxisValueLabel()
                        .font(Constants.Typography.micro)
                        .foregroundStyle(Color.textTertiary)
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(Color.appBorder)
                }
            }
            .chartYAxis {
                AxisMarks {
                    AxisValueLabel()
                        .font(Constants.Typography.caption)
                        .foregroundStyle(Color.textSecondary)
                }
            }
            .frame(height: max(60, CGFloat(dataPoints.count) * 36))
        }
    }
}

struct FlavorFrequencyChart: View {
    let dataPoints: [ChartDataPoint]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Top Flavours — High-Rated Entries")
                .font(Constants.Typography.micro)
                .foregroundStyle(Color.textTertiary)
                .tracking(0.3)
                .textCase(.uppercase)

            Chart(dataPoints) { point in
                BarMark(
                    x: .value("Count", point.value),
                    y: .value("Flavour", point.label)
                )
                .foregroundStyle(Color.ratingGold.opacity(0.85))
                .cornerRadius(2)
            }
            .chartXAxis {
                AxisMarks {
                    AxisValueLabel()
                        .font(Constants.Typography.micro)
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(Color.appBorder)
                }
            }
            .chartYAxis {
                AxisMarks {
                    AxisValueLabel()
                        .font(Constants.Typography.caption)
                        .foregroundStyle(Color.textSecondary)
                }
            }
            .frame(height: max(60, CGFloat(dataPoints.count) * 36))
        }
    }
}
