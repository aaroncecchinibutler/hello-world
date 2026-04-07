import SwiftUI

struct CoffeeInfoSection: View {
    @Bindable var vm: EntryFormViewModel

    var body: some View {
        Section("Coffee Info") {
            LabeledContent("Coffee Name") {
                TextField("e.g. Yirgacheffe Natural", text: $vm.coffeeName)
                    .multilineTextAlignment(.trailing)
            }
            LabeledContent("Roaster") {
                TextField("e.g. Onyx Coffee Lab", text: $vm.roasterName)
                    .multilineTextAlignment(.trailing)
            }
            DatePicker("Date Brewed", selection: $vm.dateBrewed, displayedComponents: .date)
        }
    }
}
