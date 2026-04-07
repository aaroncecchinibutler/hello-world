import SwiftUI
import SwiftData

struct EntryFormView: View {

    enum Mode: Equatable {
        case add
        case edit(CoffeeEntry)

        static func == (lhs: Mode, rhs: Mode) -> Bool {
            switch (lhs, rhs) {
            case (.add, .add): return true
            case (.edit(let a), .edit(let b)): return a.id == b.id
            default: return false
            }
        }
    }

    let mode: Mode

    @State private var vm = EntryFormViewModel()
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var saveError: Error? = nil
    @State private var showingSaveError = false

    var body: some View {
        NavigationStack {
            Form {
                CoffeeInfoSection(vm: vm)
                OriginSection(vm: vm)
                BrewSection(vm: vm)
                FlavorTagsSection(vm: vm)
                PhotoSection(vm: vm)
                RatingsNotesSection(vm: vm)
            }
            .navigationTitle(mode == .add ? "New Entry" : "Edit Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(!vm.isValid)
                        .fontWeight(.semibold)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) { dismiss() }
                }
            }
            .alert("Save Error", isPresented: $showingSaveError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(saveError?.localizedDescription ?? "An unexpected error occurred.")
            }
        }
        .onAppear {
            if case .edit(let entry) = mode {
                vm.load(entry: entry)
            }
        }
    }

    private func save() {
        do {
            try vm.save(context: context)
            dismiss()
        } catch {
            saveError = error
            showingSaveError = true
        }
    }
}
