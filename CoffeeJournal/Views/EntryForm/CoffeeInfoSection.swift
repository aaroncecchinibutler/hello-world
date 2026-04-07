import SwiftUI

struct CoffeeInfoSection: View {
    @Bindable var vm: EntryFormViewModel

    var body: some View {
        FormSection(title: "Coffee") {
            FormRow(label: "Name") {
                Spacer()
                TextField("e.g. Yirgacheffe Natural", text: $vm.coffeeName)
                    .font(Constants.Typography.body)
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.trailing)
            }
            FormRow(label: "Roaster") {
                Spacer()
                TextField("e.g. Onyx Coffee Lab", text: $vm.roasterName)
                    .font(Constants.Typography.body)
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.trailing)
            }
            FormRow(label: "Date Brewed") {
                Spacer()
                DatePicker("", selection: $vm.dateBrewed, displayedComponents: .date)
                    .labelsHidden()
                    .tint(Color.appAccent)
            }
        }
    }
}
