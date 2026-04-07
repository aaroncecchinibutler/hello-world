import SwiftUI

struct InsightCardView: View {
    let insight: Insight

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: iconName)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.appAccent)
                    .frame(width: 20)

                VStack(alignment: .leading, spacing: 3) {
                    Text(insight.headline)
                        .font(Constants.Typography.body.weight(.medium))
                        .foregroundStyle(Color.textPrimary)
                    Text(insight.detail)
                        .font(Constants.Typography.caption)
                        .foregroundStyle(Color.textSecondary)
                }
                Spacer()
            }
            .padding(Constants.Layout.cardPadding)

            // Chart
            if insight.type != .notEnoughData && !insight.chartData.isEmpty {
                Rectangle()
                    .fill(Color.appBorder)
                    .frame(height: Constants.Layout.borderWidth)

                chartView
                    .padding(Constants.Layout.cardPadding)
            }
        }
        .linearCard()
    }

    @ViewBuilder
    private var chartView: some View {
        switch insight.type {
        case .processingMethod:
            RatingByAttributeChart(dataPoints: insight.chartData, title: "Avg Rating by Processing", accentColor: Color.appAccent)
        case .origin:
            RatingByAttributeChart(dataPoints: insight.chartData, title: "Avg Rating by Country", accentColor: Color.appAccent.opacity(0.7))
        case .brewMethod:
            RatingByAttributeChart(dataPoints: insight.chartData, title: "Avg Rating by Brew Method", accentColor: Color.appAccent.opacity(0.55))
        case .roastLevel:
            RatingByAttributeChart(dataPoints: insight.chartData, title: "Avg Rating by Roast", accentColor: Color.appAccent.opacity(0.4))
        case .flavorFrequency:
            FlavorFrequencyChart(dataPoints: insight.chartData)
        case .brewRatio, .notEnoughData:
            EmptyView()
        }
    }

    private var iconName: String {
        switch insight.type {
        case .processingMethod: return "leaf"
        case .origin:           return "globe"
        case .brewMethod:       return "drop"
        case .roastLevel:       return "flame"
        case .flavorFrequency:  return "sparkle"
        case .brewRatio:        return "scalemass"
        case .notEnoughData:    return "chart.bar"
        }
    }
}
