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
    @State private var saveError: Error?
    @State private var showingSaveError = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 1) {
                    CoffeeInfoSection(vm: vm)
                    OriginSection(vm: vm)
                    BrewSection(vm: vm)
                    FlavorTagsSection(vm: vm)
                    PhotoSection(vm: vm)
                    RatingsNotesSection(vm: vm)
                }
                .background(Color.appBackground)
            }
            .background(Color.appBackground)
            .scrollContentBackground(.hidden)
            .navigationTitle(mode == .add ? "New Entry" : "Edit Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.appSurface, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .font(Constants.Typography.body.weight(.semibold))
                        .foregroundStyle(vm.isValid ? Color.appAccent : Color.textTertiary)
                        .disabled(!vm.isValid)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .font(Constants.Typography.body)
                        .foregroundStyle(Color.textSecondary)
                }
            }
            .alert("Couldn't Save", isPresented: $showingSaveError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(saveError?.localizedDescription ?? "An unexpected error occurred.")
            }
        }
        .onAppear {
            if case .edit(let entry) = mode { vm.load(entry: entry) }
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

// MARK: - Shared form section chrome

struct FormSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .sectionHeaderStyle()
                .padding(.horizontal, Constants.Layout.pageInset)
                .padding(.top, 16)
                .padding(.bottom, 8)

            VStack(spacing: 0) {
                content()
            }
            .background(Color.appSurface)
            .overlay(
                Rectangle()
                    .fill(Color.appBorder)
                    .frame(height: Constants.Layout.borderWidth),
                alignment: .top
            )
            .overlay(
                Rectangle()
                    .fill(Color.appBorder)
                    .frame(height: Constants.Layout.borderWidth),
                alignment: .bottom
            )
        }
    }
}

// MARK: - Single form row

struct FormRow<Content: View>: View {
    var label: String? = nil
    @ViewBuilder let content: () -> Content

    var body: some View {
        HStack {
            if let label {
                Text(label)
                    .font(Constants.Typography.body)
                    .foregroundStyle(Color.textPrimary)
            }
            content()
        }
        .padding(.horizontal, Constants.Layout.pageInset)
        .padding(.vertical, 11)
        .overlay(
            Rectangle()
                .fill(Color.appBorder)
                .frame(height: Constants.Layout.borderWidth),
            alignment: .bottom
        )
    }
}
