import SwiftUI

struct FilterSortView: View {
    @Bindable var vm: JournalViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Sort By") {
                    Picker("Sort", selection: $vm.sortOrder) {
                        ForEach(JournalViewModel.SortOrder.allCases) { order in
                            Text(order.rawValue).tag(order)
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }

                Section("Minimum Rating") {
                    HStack {
                        Text("At least \(vm.minimumRating) star\(vm.minimumRating == 1 ? "" : "s")")
                        Spacer()
                        Stepper("", value: $vm.minimumRating, in: 0...5)
                    }
                }

                Section("Processing Method") {
                    Picker("Processing", selection: $vm.selectedProcessingMethod) {
                        Text("Any").tag(ProcessingMethod?.none)
                        ForEach(ProcessingMethod.allCases) { method in
                            Text(method.displayName).tag(Optional(method))
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }

                Section("Brew Method") {
                    Picker("Brew Method", selection: $vm.selectedBrewMethod) {
                        Text("Any").tag(BrewMethod?.none)
                        ForEach(BrewMethod.allCases) { method in
                            Text(method.displayName).tag(Optional(method))
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }

                Section("Roast Level") {
                    Picker("Roast", selection: $vm.selectedRoastLevel) {
                        Text("Any").tag(RoastLevel?.none)
                        ForEach(RoastLevel.allCases) { level in
                            Text(level.displayName).tag(Optional(level))
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }
            }
            .navigationTitle("Filter & Sort")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
                ToolbarItem(placement: .topBarLeading) {
                    if vm.isFilterActive {
                        Button("Reset", role: .destructive) {
                            vm.resetFilters()
                        }
                    }
                }
            }
        }
    }
}
