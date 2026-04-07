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
            .background(Color.appBackground)
            .navigationTitle("Journal")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color.appBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddEntry = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color.appAccent)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingFilters = true
                    } label: {
                        Image(
                            systemName: vm.isFilterActive
                                ? "line.3.horizontal.decrease.circle.fill"
                                : "line.3.horizontal.decrease.circle"
                        )
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(vm.isFilterActive ? Color.appAccent : Color.textSecondary)
                    }
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
                        ? "Tap + to log your first coffee."
                        : "Try adjusting your search or filters."
                )
            } else {
                List {
                    ForEach(filteredEntries) { entry in
                        NavigationLink(destination: EntryDetailView(entry: entry)) {
                            JournalEntryRow(entry: entry)
                        }
                        .listRowBackground(Color.appSurface)
                        .listRowSeparatorTint(Color.appBorder)
                    }
                    .onDelete { indexSet in
                        for i in indexSet { context.delete(filteredEntries[i]) }
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
                .background(Color.appBackground)
            }
        }
    }
}
