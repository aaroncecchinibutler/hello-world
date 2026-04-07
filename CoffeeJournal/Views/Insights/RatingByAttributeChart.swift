import SwiftUI
import Charts

struct RatingByAttributeChart: View {
    let dataPoints: [ChartDataPoint]
    let title: String
    var accentColor: Color = .brewBrown

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Chart(dataPoints) { point in
                BarMark(
                    x: .value("Avg Rating", point.value),
                    y: .value(title, point.label)
                )
                .foregroundStyle(accentColor.gradient)
                .annotation(position: .trailing, alignment: .leading) {
                    Text(String(format: "%.1f (%d)", point.value, point.count))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .chartXScale(domain: 0...5)
            .chartXAxis {
                AxisMarks(values: [1, 2, 3, 4, 5]) { value in
                    AxisValueLabel { Text("\(value.index + 1)★") }
                    AxisGridLine()
                }
            }
            .frame(height: max(60, CGFloat(dataPoints.count) * 40))
        }
    }
}

struct FlavorFrequencyChart: View {
    let dataPoints: [ChartDataPoint]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Top Flavours in High-Rated Coffees")
                .font(.caption)
                .foregroundStyle(.secondary)

            Chart(dataPoints) { point in
                BarMark(
                    x: .value("Count", point.value),
                    y: .value("Flavour", point.label)
                )
                .foregroundStyle(Color.ratingGold.gradient)
            }
            .chartXAxis {
                AxisMarks { AxisValueLabel() }
            }
            .frame(height: max(60, CGFloat(dataPoints.count) * 40))
        }
    }
}
