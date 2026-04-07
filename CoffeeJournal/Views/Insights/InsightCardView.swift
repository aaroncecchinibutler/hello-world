import SwiftUI

struct InsightCardView: View {
    let insight: Insight

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(insight.headline)
                        .font(.headline)
                    Text(insight.detail)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: iconName)
                    .font(.title2)
                    .foregroundStyle(Color.brewBrown)
            }

            // Chart
            if insight.type != .notEnoughData && !insight.chartData.isEmpty {
                Divider()
                chartView
            }
        }
        .cardStyle()
    }

    @ViewBuilder
    private var chartView: some View {
        switch insight.type {
        case .processingMethod:
            RatingByAttributeChart(dataPoints: insight.chartData, title: "Avg Rating by Processing", accentColor: .brewBrown)
        case .origin:
            RatingByAttributeChart(dataPoints: insight.chartData, title: "Avg Rating by Country", accentColor: .teal)
        case .brewMethod:
            RatingByAttributeChart(dataPoints: insight.chartData, title: "Avg Rating by Brew Method", accentColor: .indigo)
        case .roastLevel:
            RatingByAttributeChart(dataPoints: insight.chartData, title: "Avg Rating by Roast Level", accentColor: .orange)
        case .flavorFrequency:
            FlavorFrequencyChart(dataPoints: insight.chartData)
        case .brewRatio, .notEnoughData:
            EmptyView()
        }
    }

    private var iconName: String {
        switch insight.type {
        case .processingMethod: return "leaf.fill"
        case .origin:           return "globe"
        case .brewMethod:       return "drop.fill"
        case .roastLevel:       return "flame.fill"
        case .flavorFrequency:  return "star.fill"
        case .brewRatio:        return "scalemass.fill"
        case .notEnoughData:    return "chart.bar.xaxis"
        }
    }
}
