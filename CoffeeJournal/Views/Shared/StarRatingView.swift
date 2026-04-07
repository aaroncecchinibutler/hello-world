import SwiftUI

// MARK: - Linear-style star rating
// Smaller, more precise. Uses filled dot for rated, ring for unrated — cleaner than star outlines.
// Falls back to actual stars for accessibility.

struct StarRatingView: View {
    @Binding var rating: Int
    var isInteractive: Bool = true
    var starSize: CGFloat = 22

    var body: some View {
        HStack(spacing: 3) {
            ForEach(1...5, id: \.self) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                    .font(.system(size: starSize, weight: .light))
                    .foregroundStyle(star <= rating ? Color.ratingGold : Color.appBorder)
                    .onTapGesture {
                        guard isInteractive else { return }
                        withAnimation(.easeInOut(duration: 0.1)) { rating = star }
                    }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Rating: \(rating) out of 5 stars")
        .accessibilityAdjustableAction { direction in
            guard isInteractive else { return }
            switch direction {
            case .increment: rating = min(5, rating + 1)
            case .decrement: rating = max(1, rating - 1)
            @unknown default: break
            }
        }
    }
}

struct StarRatingDisplayView: View {
    let rating: Int
    var starSize: CGFloat = 11

    @State private var _rating: Int

    init(rating: Int, starSize: CGFloat = 11) {
        self.rating = rating
        self.starSize = starSize
        self._rating = State(initialValue: rating)
    }

    var body: some View {
        StarRatingView(rating: $_rating, isInteractive: false, starSize: starSize)
    }
}
