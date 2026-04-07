import SwiftUI

extension View {

    /// Applies a card-style background with rounded corners and shadow
    func cardStyle() -> some View {
        self
            .padding(Constants.Layout.cardPadding)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: Constants.Layout.cornerRadius))
            .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
    }

    /// Hides the view conditionally without removing it from the layout
    func hidden(_ isHidden: Bool) -> some View {
        opacity(isHidden ? 0 : 1)
    }

    /// Shows a loading overlay when condition is true
    func loadingOverlay(_ isLoading: Bool) -> some View {
        overlay {
            if isLoading {
                ZStack {
                    Color.black.opacity(0.2)
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.5)
                }
                .ignoresSafeArea()
            }
        }
    }
}
