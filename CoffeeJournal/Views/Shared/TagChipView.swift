import SwiftUI

struct TagChipView: View {
    let name: String
    var isSelected: Bool = false
    var onTap: (() -> Void)? = nil

    var body: some View {
        Text(name)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(isSelected ? Color.brewBrown : Color(uiColor: .tertiarySystemFill))
            .foregroundStyle(isSelected ? .white : .primary)
            .clipShape(Capsule())
            .onTapGesture { onTap?() }
            .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

/// A wrapping flow layout for tag chips
struct TagCloudView: View {
    let tags: [String]
    var selectedTags: Set<String> = []
    var onToggle: ((String) -> Void)? = nil

    @State private var totalHeight: CGFloat = .zero

    var body: some View {
        GeometryReader { geo in
            self.generateContent(in: geo)
        }
        .frame(height: totalHeight)
    }

    private func generateContent(in geo: GeometryProxy) -> some View {
        var width: CGFloat = 0
        var height: CGFloat = 0

        return ZStack(alignment: .topLeading) {
            ForEach(tags, id: \.self) { tag in
                TagChipView(
                    name: tag,
                    isSelected: selectedTags.contains(tag)
                ) {
                    onToggle?(tag)
                }
                .alignmentGuide(.leading) { d in
                    if abs(width - d.width) > geo.size.width {
                        width = 0
                        height -= d.height + 6
                    }
                    let result = width
                    if tag == tags.last { width = 0 }
                    else { width -= d.width + 6 }
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
                Color.clear.preference(key: HeightKey.self, value: geo.size.height)
            }
        )
        .onPreferenceChange(HeightKey.self) { totalHeight = $0 }
    }
}

private struct HeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
