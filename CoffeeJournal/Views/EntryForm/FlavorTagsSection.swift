import SwiftUI

struct FlavorTagsSection: View {
    @Bindable var vm: EntryFormViewModel
    @State private var customTag: String = ""
    @State private var selectedCategory: FlavorCategory? = nil

    var filteredPresets: [(name: String, category: FlavorCategory)] {
        guard let cat = selectedCategory else { return Constants.Flavor.presetTags }
        return Constants.Flavor.presetTags.filter { $0.category == cat }
    }

    var body: some View {
        FormSection(title: "Flavour Notes") {
            // Category filter strip
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5) {
                    TagChipView(name: "All", isSelected: selectedCategory == nil) {
                        selectedCategory = nil
                    }
                    ForEach(FlavorCategory.allCases) { cat in
                        TagChipView(
                            name: "\(cat.emoji) \(cat.displayName)",
                            isSelected: selectedCategory == cat
                        ) {
                            selectedCategory = selectedCategory == cat ? nil : cat
                        }
                    }
                }
                .padding(.horizontal, Constants.Layout.pageInset)
                .padding(.vertical, 10)
            }
            .overlay(
                Rectangle().fill(Color.appBorder).frame(height: Constants.Layout.borderWidth),
                alignment: .bottom
            )

            // Tag cloud
            TagCloudView(
                tags: filteredPresets.map(\.name),
                selectedTags: vm.selectedFlavorTagNames
            ) { tag in
                if vm.selectedFlavorTagNames.contains(tag) {
                    vm.selectedFlavorTagNames.remove(tag)
                } else {
                    vm.selectedFlavorTagNames.insert(tag)
                }
            }
            .padding(.horizontal, Constants.Layout.pageInset)
            .padding(.vertical, 12)
            .overlay(
                Rectangle().fill(Color.appBorder).frame(height: Constants.Layout.borderWidth),
                alignment: .bottom
            )

            // Custom tag input
            HStack(spacing: 8) {
                TextField("Add custom note…", text: $customTag)
                    .font(Constants.Typography.body)
                    .foregroundStyle(Color.textPrimary)
                    .submitLabel(.done)
                    .onSubmit { addCustomTag() }

                if !customTag.trimmingCharacters(in: .whitespaces).isEmpty {
                    Button("Add") { addCustomTag() }
                        .buttonStyle(LinearButtonStyle())
                }
            }
            .padding(.horizontal, Constants.Layout.pageInset)
            .padding(.vertical, 10)
            .overlay(
                Rectangle().fill(Color.appBorder).frame(height: Constants.Layout.borderWidth),
                alignment: .bottom
            )

            // Selected summary
            if !vm.selectedFlavorTagNames.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5) {
                        ForEach(vm.selectedFlavorTagNames.sorted(), id: \.self) { tag in
                            TagChipView(name: tag, isSelected: true) {
                                vm.selectedFlavorTagNames.remove(tag)
                            }
                        }
                    }
                    .padding(.horizontal, Constants.Layout.pageInset)
                    .padding(.vertical, 8)
                }
            }
        }
    }

    private func addCustomTag() {
        let t = customTag.trimmingCharacters(in: .whitespaces)
        guard !t.isEmpty else { return }
        vm.selectedFlavorTagNames.insert(t)
        customTag = ""
    }
}
