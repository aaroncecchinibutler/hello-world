import SwiftUI

struct OriginSection: View {
    @Bindable var vm: EntryFormViewModel

    var body: some View {
        Section("Origin") {
            LabeledContent("Country") {
                TextField("e.g. Ethiopia", text: $vm.originCountry)
                    .multilineTextAlignment(.trailing)
            }
            LabeledContent("Region") {
                TextField("e.g. Yirgacheffe", text: $vm.originRegion)
                    .multilineTextAlignment(.trailing)
            }
            LabeledContent("Farm / Producer") {
                TextField("Optional", text: $vm.originFarm)
                    .multilineTextAlignment(.trailing)
            }
            Picker("Processing", selection: $vm.processingMethod) {
                ForEach(ProcessingMethod.allCases) { method in
                    Text(method.displayName).tag(method)
                }
            }
            Picker("Roast Level", selection: $vm.roastLevel) {
                ForEach(RoastLevel.allCases) { level in
                    Text(level.displayName).tag(level)
                }
            }
        }
    }
}
