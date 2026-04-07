import SwiftUI

struct FilterSortView: View {
    @Bindable var vm: JournalViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 1) {
                    filterSection(title: "Sort By") {
                        ForEach(JournalViewModel.SortOrder.allCases) { order in
                            filterRow {
                                Text(order.rawValue)
                                    .font(Constants.Typography.body)
                                    .foregroundStyle(Color.textPrimary)
                                Spacer()
                                if vm.sortOrder == order {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(Color.appAccent)
                                }
                            }
                            .onTapGesture { vm.sortOrder = order }
                        }
                    }

                    filterSection(title: "Minimum Rating") {
                        filterRow {
                            Text("At least")
                                .font(Constants.Typography.body)
                                .foregroundStyle(Color.textPrimary)
                            Spacer()
                            HStack(spacing: 6) {
                                Button {
                                    vm.minimumRating = max(0, vm.minimumRating - 1)
                                } label: {
                                    Image(systemName: "minus")
                                        .font(.system(size: 13))
                                        .foregroundStyle(Color.textSecondary)
                                        .frame(width: 28, height: 28)
                                        .background(Color.appSurfaceSunken)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.appBorder, lineWidth: Constants.Layout.borderWidth))
                                }
                                Text("\(vm.minimumRating)★")
                                    .font(Constants.Typography.mono)
                                    .foregroundStyle(Color.textPrimary)
                                    .frame(width: 28, alignment: .center)
                                Button {
                                    vm.minimumRating = min(5, vm.minimumRating + 1)
                                } label: {
                                    Image(systemName: "plus")
                                        .font(.system(size: 13))
                                        .foregroundStyle(Color.textSecondary)
                                        .frame(width: 28, height: 28)
                                        .background(Color.appSurfaceSunken)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.appBorder, lineWidth: Constants.Layout.borderWidth))
                                }
                            }
                        }
                    }

                    filterSection(title: "Processing Method") {
                        optionRow(label: "Any", isSelected: vm.selectedProcessingMethod == nil) {
                            vm.selectedProcessingMethod = nil
                        }
                        ForEach(ProcessingMethod.allCases) { method in
                            optionRow(label: method.displayName, isSelected: vm.selectedProcessingMethod == method) {
                                vm.selectedProcessingMethod = method
                            }
                        }
                    }

                    filterSection(title: "Brew Method") {
                        optionRow(label: "Any", isSelected: vm.selectedBrewMethod == nil) {
                            vm.selectedBrewMethod = nil
                        }
                        ForEach(BrewMethod.allCases) { method in
                            optionRow(label: method.displayName, isSelected: vm.selectedBrewMethod == method) {
                                vm.selectedBrewMethod = method
                            }
                        }
                    }

                    filterSection(title: "Roast Level") {
                        optionRow(label: "Any", isSelected: vm.selectedRoastLevel == nil) {
                            vm.selectedRoastLevel = nil
                        }
                        ForEach(RoastLevel.allCases) { level in
                            optionRow(label: level.displayName, isSelected: vm.selectedRoastLevel == level) {
                                vm.selectedRoastLevel = level
                            }
                        }
                    }
                }
                .padding(.top, 8)
            }
            .background(Color.appBackground)
            .navigationTitle("Filter & Sort")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.appSurface, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                        .font(Constants.Typography.body.weight(.medium))
                        .foregroundStyle(Color.appAccent)
                }
                if vm.isFilterActive {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Reset") { vm.resetFilters() }
                            .font(Constants.Typography.body)
                            .foregroundStyle(Color.textTertiary)
                    }
                }
            }
        }
    }

    private func filterSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .sectionHeaderStyle()
                .padding(.horizontal, Constants.Layout.pageInset)
                .padding(.top, 14)
                .padding(.bottom, 6)
            VStack(spacing: 0) {
                content()
            }
            .background(Color.appSurface)
            .overlay(Rectangle().fill(Color.appBorder).frame(height: Constants.Layout.borderWidth), alignment: .top)
            .overlay(Rectangle().fill(Color.appBorder).frame(height: Constants.Layout.borderWidth), alignment: .bottom)
        }
    }

    private func filterRow<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        HStack(spacing: 8) { content() }
            .padding(.horizontal, Constants.Layout.pageInset)
            .padding(.vertical, 11)
            .overlay(Rectangle().fill(Color.appBorder).frame(height: Constants.Layout.borderWidth), alignment: .bottom)
    }

    private func optionRow(label: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        filterRow {
            Text(label)
                .font(Constants.Typography.body)
                .foregroundStyle(isSelected ? Color.textPrimary : Color.textSecondary)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.appAccent)
            }
        }
        .onTapGesture { action() }
    }
}
