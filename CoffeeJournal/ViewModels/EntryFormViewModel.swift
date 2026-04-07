import Foundation
import SwiftData
import UIKit

@Observable
final class EntryFormViewModel {

    // MARK: - Form fields (mirror CoffeeEntry)

    var coffeeName: String = ""
    var roasterName: String = ""
    var originCountry: String = ""
    var originRegion: String = ""
    var originFarm: String = ""

    var processingMethod: ProcessingMethod = .washed
    var roastLevel: RoastLevel = .medium
    var brewMethod: BrewMethod = .pourOver
    var brewParameters: BrewParameters = .default

    var selectedFlavorTagNames: Set<String> = []
    var rating: Int = 3
    var dateBrewed: Date = Date()
    var personalNotes: String = ""

    // Photos staged for this entry (before saving)
    var stagedPhotos: [CoffeePhoto] = []

    // MARK: - UI sheet state

    var showingImagePicker: Bool = false
    var showingCamera: Bool = false
    var showingImageSearch: Bool = false
    var showingURLInput: Bool = false
    var pendingURLInput: String = ""

    // MARK: - Edit mode

    private(set) var isEditing: Bool = false
    private weak var existingEntryRef: CoffeeEntry?

    // MARK: - Validation

    var isValid: Bool {
        !coffeeName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !roasterName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var validationMessage: String? {
        if coffeeName.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Coffee name is required."
        }
        if roasterName.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Roaster name is required."
        }
        return nil
    }

    // MARK: - Load from existing entry (edit mode)

    func load(entry: CoffeeEntry) {
        isEditing = true
        existingEntryRef = entry

        coffeeName     = entry.coffeeName
        roasterName    = entry.roasterName
        originCountry  = entry.originCountry
        originRegion   = entry.originRegion
        originFarm     = entry.originFarm ?? ""
        processingMethod = entry.processingMethod
        roastLevel     = entry.roastLevel
        brewMethod     = entry.brewMethod
        brewParameters = entry.brewParameters
        rating         = entry.rating
        dateBrewed     = entry.dateBrewed
        personalNotes  = entry.personalNotes
        selectedFlavorTagNames = Set(entry.flavorTagNames)
        stagedPhotos   = entry.photos
    }

    // MARK: - Save

    func save(context: ModelContext) throws {
        let entry: CoffeeEntry
        if isEditing, let existing = existingEntryRef {
            entry = existing
        } else {
            entry = CoffeeEntry()
            context.insert(entry)
        }

        entry.coffeeName      = coffeeName.trimmingCharacters(in: .whitespaces)
        entry.roasterName     = roasterName.trimmingCharacters(in: .whitespaces)
        entry.originCountry   = originCountry.trimmingCharacters(in: .whitespaces)
        entry.originRegion    = originRegion.trimmingCharacters(in: .whitespaces)
        entry.originFarm      = originFarm.trimmingCharacters(in: .whitespaces).isEmpty ? nil : originFarm
        entry.processingMethod = processingMethod
        entry.roastLevel      = roastLevel
        entry.brewMethod      = brewMethod
        entry.brewParameters  = brewParameters
        entry.rating          = rating
        entry.dateBrewed      = dateBrewed
        entry.personalNotes   = personalNotes
        entry.photos          = stagedPhotos

        // Resolve FlavorTag objects (find existing or create)
        let existingTags = try context.fetch(FetchDescriptor<FlavorTag>())
        var tagObjects: [FlavorTag] = []
        for name in selectedFlavorTagNames {
            if let found = existingTags.first(where: { $0.name.lowercased() == name.lowercased() }) {
                tagObjects.append(found)
            } else {
                let category = Constants.Flavor.presetTags.first { $0.name.lowercased() == name.lowercased() }?.category ?? .earthy
                let newTag = FlavorTag(name: name, category: category)
                context.insert(newTag)
                tagObjects.append(newTag)
            }
        }
        entry.flavorTags = tagObjects

        try context.save()
    }

    // MARK: - Photo helpers

    func addPhoto(from image: UIImage, source: PhotoSource) {
        let data = image.jpegData(compressionQuality: 0.8)
        let photo = CoffeePhoto(imageData: data, source: source)
        stagedPhotos.append(photo)
    }

    func addPhoto(fromURLString urlString: String) {
        guard !urlString.isEmpty, URL(string: urlString) != nil else { return }
        let photo = CoffeePhoto(remoteURLString: urlString, source: .url)
        stagedPhotos.append(photo)
    }

    func addPhoto(from result: ImageSearchResult) {
        let photo = CoffeePhoto(remoteURLString: result.fullsizeURL.absoluteString, source: .webSearch)
        stagedPhotos.append(photo)
    }

    func removePhoto(at offsets: IndexSet) {
        stagedPhotos.remove(atOffsets: offsets)
    }
}
