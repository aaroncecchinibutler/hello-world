import SwiftUI

// MARK: - Linear-style modifiers

extension View {

    /// Surface card: solid background + 1 pt border, no shadow.
    /// Linear's aesthetic avoids drop shadows entirely.
    func linearCard() -> some View {
        self
            .padding(Constants.Layout.cardPadding)
            .background(Color.appSurface)
            .clipShape(RoundedRectangle(cornerRadius: Constants.Layout.cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: Constants.Layout.cornerRadius)
                    .strokeBorder(Color.appBorder, lineWidth: Constants.Layout.borderWidth)
            )
    }

    /// Inset / sunken surface (text inputs, segmented areas)
    func linearInset() -> some View {
        self
            .padding(Constants.Layout.rowPadding)
            .background(Color.appSurfaceSunken)
            .clipShape(RoundedRectangle(cornerRadius: Constants.Layout.cornerRadius - 1))
            .overlay(
                RoundedRectangle(cornerRadius: Constants.Layout.cornerRadius - 1)
                    .strokeBorder(Color.appBorder, lineWidth: Constants.Layout.borderWidth)
            )
    }

    /// Full-width divider at 1 physical pixel
    func hairlineDivider() -> some View {
        self.overlay(
            Divider()
                .frame(maxWidth: .infinity, maxHeight: Constants.Layout.borderWidth)
                .background(Color.appBorder),
            alignment: .bottom
        )
    }

    /// Section header in Linear's small-caps label style
    func sectionHeaderStyle() -> some View {
        self
            .font(Constants.Typography.label)
            .foregroundStyle(Color.textTertiary)
            .textCase(.uppercase)
            .tracking(0.4)
    }

    func hidden(_ isHidden: Bool) -> some View {
        opacity(isHidden ? 0 : 1)
    }

    func loadingOverlay(_ isLoading: Bool) -> some View {
        overlay {
            if isLoading {
                ZStack {
                    Color.appBackground.opacity(0.7)
                    ProgressView()
                        .tint(Color.appAccent)
                }
                .ignoresSafeArea()
            }
        }
    }
}

// MARK: - Linear-style button style

struct LinearButtonStyle: ButtonStyle {
    var isDestructive: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Constants.Typography.body.weight(.medium))
            .foregroundStyle(isDestructive ? .red : Color.appAccent)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: Constants.Layout.cornerRadius)
                    .fill(configuration.isPressed
                          ? Color.appBorder
                          : Color.appAccentSubtle)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Constants.Layout.cornerRadius)
                    .strokeBorder(Color.appBorder, lineWidth: Constants.Layout.borderWidth)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

/// Primary filled button (used for CTAs)
struct LinearPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Constants.Typography.body.weight(.semibold))
            .foregroundStyle(Color.appBackground)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: Constants.Layout.cornerRadius)
                    .fill(configuration.isPressed
                          ? Color.appAccent.opacity(0.85)
                          : Color.appAccent)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
