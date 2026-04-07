import SwiftUI

struct FlavorTagsSection: View {
    @Bindable var vm: EntryFormViewModel
    @State private var customTag: String = ""
    @State private var selectedCategory: FlavorCategory? = nil

    var filteredPresets: [(name: String, category: FlavorCategory)] {
        guard let cat = selectedCategory else {
            return Constants.Flavor.presetTags
        }
        return Constants.Flavor.presetTags.filter { $0.category == cat }
    }

    var body: some View {
        Section("Flavour Notes") {
            // Category filter pills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
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
                .padding(.vertical, 4)
            }

            // Preset tag cloud
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

            // Custom tag input
            HStack {
                TextField("Add custom note…", text: $customTag)
                    .submitLabel(.done)
                    .onSubmit { addCustomTag() }
                Button("Add") { addCustomTag() }
                    .disabled(customTag.trimmingCharacters(in: .whitespaces).isEmpty)
            }

            // Selected tags summary
            if !vm.selectedFlavorTagNames.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(vm.selectedFlavorTagNames.sorted(), id: \.self) { tag in
                            TagChipView(name: tag, isSelected: true) {
                                vm.selectedFlavorTagNames.remove(tag)
                            }
                        }
                    }
                }
            }
        }
    }

    private func addCustomTag() {
        let trimmed = customTag.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        vm.selectedFlavorTagNames.insert(trimmed)
        customTag = ""
    }
}
