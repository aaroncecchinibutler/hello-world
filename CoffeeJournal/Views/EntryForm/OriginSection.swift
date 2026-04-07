import SwiftUI

struct OriginSection: View {
    @Bindable var vm: EntryFormViewModel

    var body: some View {
        FormSection(title: "Origin") {
            FormRow(label: "Country") {
                Spacer()
                TextField("e.g. Ethiopia", text: $vm.originCountry)
                    .font(Constants.Typography.body)
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.trailing)
            }
            FormRow(label: "Region") {
                Spacer()
                TextField("e.g. Yirgacheffe", text: $vm.originRegion)
                    .font(Constants.Typography.body)
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.trailing)
            }
            FormRow(label: "Farm") {
                Spacer()
                TextField("Optional", text: $vm.originFarm)
                    .font(Constants.Typography.body)
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.trailing)
            }
            FormRow(label: "Processing") {
                Spacer()
                Picker("", selection: $vm.processingMethod) {
                    ForEach(ProcessingMethod.allCases) { m in
                        Text(m.displayName).tag(m)
                    }
                }
                .tint(Color.textSecondary)
            }
            FormRow(label: "Roast") {
                Spacer()
                Picker("", selection: $vm.roastLevel) {
                    ForEach(RoastLevel.allCases) { l in
                        Text(l.displayName).tag(l)
                    }
                }
                .tint(Color.textSecondary)
            }
        }
    }
}
