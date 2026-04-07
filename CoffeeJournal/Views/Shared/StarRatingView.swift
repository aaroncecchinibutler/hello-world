import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Int
    var isInteractive: Bool = true
    var starSize: CGFloat = 28

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                    .foregroundStyle(star <= rating ? Color.ratingGold : Color.secondary)
                    .font(.system(size: starSize))
                    .onTapGesture {
                        guard isInteractive else { return }
                        withAnimation(.easeInOut(duration: 0.1)) {
                            rating = star
                        }
                    }
                    .accessibilityLabel("\(star) star\(star == 1 ? "" : "s")")
                    .accessibilityAddTraits(star == rating ? .isSelected : [])
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

// Display-only convenience
struct StarRatingDisplayView: View {
    let rating: Int
    var starSize: CGFloat = 14

    @State private var _rating: Int

    init(rating: Int, starSize: CGFloat = 14) {
        self.rating = rating
        self.starSize = starSize
        self._rating = State(initialValue: rating)
    }

    var body: some View {
        StarRatingView(rating: $_rating, isInteractive: false, starSize: starSize)
    }
}

#Preview {
    VStack(spacing: 20) {
        StarRatingView(rating: .constant(4))
        StarRatingDisplayView(rating: 3, starSize: 20)
    }
    .padding()
}
