import SwiftUI

struct EmptyStateView: View {
    let systemImage: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 28, weight: .light))
                .foregroundStyle(Color.textTertiary)

            VStack(spacing: 4) {
                Text(title)
                    .font(Constants.Typography.body.weight(.medium))
                    .foregroundStyle(Color.textPrimary)

                Text(message)
                    .font(Constants.Typography.caption)
                    .foregroundStyle(Color.textTertiary)
                    .multilineTextAlignment(.center)
            }

            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .buttonStyle(LinearButtonStyle())
                    .padding(.top, 4)
            }
        }
        .padding(Constants.Layout.cardPadding * 2)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
