import Foundation

extension Date {

    var journalDisplayDate: String {
        formatted(date: .abbreviated, time: .omitted)
    }

    var journalDisplayDateTime: String {
        formatted(date: .abbreviated, time: .shortened)
    }

    var relativeDisplay: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
