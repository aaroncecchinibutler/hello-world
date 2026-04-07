import SwiftUI

struct RatingsNotesSection: View {
    @Bindable var vm: EntryFormViewModel

    var body: some View {
        Section("Your Take") {
            VStack(alignment: .leading, spacing: 8) {
                Text("Rating")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                HStack {
                    StarRatingView(rating: $vm.rating)
                    Spacer()
                    Text(ratingLabel)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 4)

            VStack(alignment: .leading, spacing: 4) {
                Text("Notes")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                TextEditor(text: $vm.personalNotes)
                    .frame(minHeight: 80)
            }
            .padding(.vertical, 4)
        }
    }

    private var ratingLabel: String {
        switch vm.rating {
        case 1: return "Wouldn't order again"
        case 2: return "Decent"
        case 3: return "Enjoyable"
        case 4: return "Really good"
        case 5: return "Exceptional"
        default: return ""
        }
    }
}
