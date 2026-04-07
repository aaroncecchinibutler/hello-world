import SwiftUI
import SwiftData

struct JournalListView: View {
    @Environment(\.modelContext) private var context
    @State private var vm = JournalViewModel()
    @State private var showingAddEntry = false
    @State private var showingFilters = false

    var body: some View {
        NavigationStack {
            QueryableJournalList(
                predicate: vm.predicate,
                sortDescriptors: vm.sortDescriptors,
                clientFilter: vm.filter
            )
            .searchable(text: $vm.searchText, prompt: "Search coffees, roasters, origins…")
            .navigationTitle("Coffee Journal")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddEntry = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add entry")
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingFilters = true
                    } label: {
                        Label("Filter", systemImage: vm.isFilterActive ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                    }
                    .accessibilityLabel(vm.isFilterActive ? "Filters active" : "Filter entries")
                }
            }
            .sheet(isPresented: $showingAddEntry) {
                EntryFormView(mode: .add)
            }
            .sheet(isPresented: $showingFilters) {
                FilterSortView(vm: vm)
            }
        }
    }
}

// MARK: - QueryableJournalList
// Separate child view owns @Query so it can receive runtime predicate + sort at init time.

struct QueryableJournalList: View {
    @Environment(\.modelContext) private var context
    @Query var entries: [CoffeeEntry]

    let clientFilter: ([CoffeeEntry]) -> [CoffeeEntry]

    init(
        predicate: Predicate<CoffeeEntry>,
        sortDescriptors: [SortDescriptor<CoffeeEntry>],
        clientFilter: @escaping ([CoffeeEntry]) -> [CoffeeEntry]
    ) {
        _entries = Query(filter: predicate, sort: sortDescriptors)
        self.clientFilter = clientFilter
    }

    var filteredEntries: [CoffeeEntry] { clientFilter(entries) }

    var body: some View {
        Group {
            if filteredEntries.isEmpty {
                EmptyStateView(
                    systemImage: "cup.and.saucer",
                    title: entries.isEmpty ? "No Entries Yet" : "No Matches",
                    message: entries.isEmpty
                        ? "Start by adding your first coffee journal entry."
                        : "Try adjusting your search or filters.",
                    actionTitle: entries.isEmpty ? "Add Coffee" : nil,
                    action: nil
                )
            } else {
                List {
                    ForEach(filteredEntries) { entry in
                        NavigationLink(destination: EntryDetailView(entry: entry)) {
                            JournalEntryRow(entry: entry)
                        }
                    }
                    .onDelete { indexSet in
                        for i in indexSet {
                            context.delete(filteredEntries[i])
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
    }
}
