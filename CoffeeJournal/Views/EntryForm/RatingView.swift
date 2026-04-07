import SwiftUI

struct RatingsNotesSection: View {
    @Bindable var vm: EntryFormViewModel

    var body: some View {
        FormSection(title: "Your Take") {
            // Rating row
            FormRow {
                Text("Rating")
                    .font(Constants.Typography.body)
                    .foregroundStyle(Color.textPrimary)
                Spacer()
                HStack(spacing: 8) {
                    StarRatingView(rating: $vm.rating, starSize: 20)
                    Text(ratingLabel)
                        .font(Constants.Typography.caption)
                        .foregroundStyle(Color.textTertiary)
                        .frame(width: 96, alignment: .leading)
                }
            }

            // Notes
            VStack(alignment: .leading, spacing: 6) {
                Text("Notes")
                    .font(Constants.Typography.caption)
                    .foregroundStyle(Color.textTertiary)

                TextEditor(text: $vm.personalNotes)
                    .font(Constants.Typography.body)
                    .foregroundStyle(Color.textPrimary)
                    .frame(minHeight: 80)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
            }
            .padding(.horizontal, Constants.Layout.pageInset)
            .padding(.vertical, 12)
        }
    }

    private var ratingLabel: String {
        switch vm.rating {
        case 1: return "Avoid"
        case 2: return "Decent"
        case 3: return "Good"
        case 4: return "Great"
        case 5: return "Exceptional"
        default: return ""
        }
    }
}
