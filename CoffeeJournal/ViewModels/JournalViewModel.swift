import Foundation
import SwiftData
import Observation

@Observable
final class JournalViewModel {

    // MARK: - Filter & Search state

    var searchText: String = ""
    var selectedBrewMethod: BrewMethod? = nil
    var selectedProcessingMethod: ProcessingMethod? = nil
    var selectedRoastLevel: RoastLevel? = nil
    var minimumRating: Int = 0
    var sortOrder: SortOrder = .dateDescending

    var isFilterActive: Bool {
        selectedBrewMethod != nil ||
        selectedProcessingMethod != nil ||
        selectedRoastLevel != nil ||
        minimumRating > 0
    }

    // MARK: - Sort

    enum SortOrder: String, CaseIterable, Identifiable {
        case dateDescending    = "Newest First"
        case dateAscending     = "Oldest First"
        case ratingDescending  = "Highest Rated"
        case coffeeName        = "Coffee Name"

        var id: String { rawValue }

        var sortDescriptors: [SortDescriptor<CoffeeEntry>] {
            switch self {
            case .dateDescending:   return [SortDescriptor(\.dateBrewed, order: .reverse)]
            case .dateAscending:    return [SortDescriptor(\.dateBrewed)]
            case .ratingDescending: return [SortDescriptor(\.rating, order: .reverse), SortDescriptor(\.dateBrewed, order: .reverse)]
            case .coffeeName:       return [SortDescriptor(\.coffeeName)]
            }
        }
    }

    // MARK: - Predicate

    /// Dynamic predicate for use with @Query in QueryableJournalList.
    /// NOTE: SwiftData #Predicate has limited support for complex conditions;
    /// post-filtering is applied in QueryableJournalList when needed.
    var predicate: Predicate<CoffeeEntry> {
        let minRating = minimumRating
        let search = searchText.lowercased()

        if search.isEmpty {
            return #Predicate<CoffeeEntry> { entry in
                entry.rating >= minRating
            }
        } else {
            return #Predicate<CoffeeEntry> { entry in
                entry.rating >= minRating &&
                (entry.coffeeName.localizedStandardContains(search) ||
                 entry.roasterName.localizedStandardContains(search) ||
                 entry.originCountry.localizedStandardContains(search))
            }
        }
    }

    var sortDescriptors: [SortDescriptor<CoffeeEntry>] {
        sortOrder.sortDescriptors
    }

    // MARK: - Actions

    func resetFilters() {
        selectedBrewMethod = nil
        selectedProcessingMethod = nil
        selectedRoastLevel = nil
        minimumRating = 0
    }

    func delete(_ entry: CoffeeEntry, context: ModelContext) {
        context.delete(entry)
    }

    /// Client-side filter for attributes SwiftData #Predicate can't handle (enum rawValue matching)
    func filter(_ entries: [CoffeeEntry]) -> [CoffeeEntry] {
        entries.filter { entry in
            if let bm = selectedBrewMethod, entry.brewMethod != bm { return false }
            if let pm = selectedProcessingMethod, entry.processingMethod != pm { return false }
            if let rl = selectedRoastLevel, entry.roastLevel != rl { return false }
            return true
        }
    }
}
