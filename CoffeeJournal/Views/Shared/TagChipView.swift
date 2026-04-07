import SwiftUI

// MARK: - Linear-style tag chip
// Small, precise, border-driven. Selected state inverts to accent fill.

struct TagChipView: View {
    let name: String
    var isSelected: Bool = false
    var onTap: (() -> Void)? = nil

    var body: some View {
        Text(name)
            .font(Constants.Typography.micro)
            .tracking(0.1)
            .foregroundStyle(isSelected ? Color.appBackground : Color.textSecondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(isSelected ? Color.appAccent : Color.appSurface)
            )
            .overlay(
                Capsule()
                    .strokeBorder(
                        isSelected ? Color.appAccent : Color.appBorder,
                        lineWidth: Constants.Layout.borderWidth
                    )
            )
            .onTapGesture { onTap?() }
            .animation(.easeInOut(duration: 0.12), value: isSelected)
    }
}

// MARK: - Wrapping flow layout

struct TagCloudView: View {
    let tags: [String]
    var selectedTags: Set<String> = []
    var onToggle: ((String) -> Void)? = nil

    @State private var totalHeight: CGFloat = .zero

    var body: some View {
        GeometryReader { geo in
            generateContent(in: geo)
        }
        .frame(height: totalHeight)
    }

    private func generateContent(in geo: GeometryProxy) -> some View {
        var width: CGFloat = 0
        var height: CGFloat = 0

        return ZStack(alignment: .topLeading) {
            ForEach(tags, id: \.self) { tag in
                TagChipView(name: tag, isSelected: selectedTags.contains(tag)) {
                    onToggle?(tag)
                }
                .alignmentGuide(.leading) { d in
                    if abs(width - d.width) > geo.size.width {
                        width = 0; height -= d.height + 5
                    }
                    let result = width
                    if tag == tags.last { width = 0 } else { width -= d.width + 5 }
                    return result
                }
                .alignmentGuide(.top) { _ in
                    let result = height
                    if tag == tags.last { height = 0 }
                    return result
                }
            }
        }
        .background(
            GeometryReader { geo in
                Color.clear.preference(key: TagCloudHeightKey.self, value: geo.size.height)
            }
        )
        .onPreferenceChange(TagCloudHeightKey.self) { totalHeight = $0 }
    }
}

private struct TagCloudHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
