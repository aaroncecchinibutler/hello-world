import SwiftUI

struct BrewSection: View {
    @Bindable var vm: EntryFormViewModel

    var body: some View {
        Section("Brew") {
            Picker("Method", selection: $vm.brewMethod) {
                ForEach(BrewMethod.allCases) { method in
                    Text(method.displayName).tag(method)
                }
            }

            Picker("Grind Size", selection: $vm.brewParameters.grindSize) {
                ForEach(GrindSize.allCases) { size in
                    Text(size.displayName).tag(size)
                }
            }

            // Numeric grind setting (optional)
            HStack {
                Text("Grind Setting")
                    .foregroundStyle(.primary)
                Spacer()
                if let numeric = vm.brewParameters.grindNumeric {
                    Text(String(format: "%.0f", numeric))
                        .foregroundStyle(.secondary)
                }
                TextField("Clicks/Setting", value: $vm.brewParameters.grindNumeric, format: .number)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .frame(width: 80)
                    .foregroundStyle(.secondary)
            }

            // Dose
            HStack {
                Text("Dose")
                Spacer()
                Text(String(format: "%.1f g", vm.brewParameters.dosageGrams))
                    .foregroundStyle(.secondary)
            }
            Slider(
                value: $vm.brewParameters.dosageGrams,
                in: Constants.Brew.doseRange,
                step: 0.5
            )

            // Water
            HStack {
                Text("Water")
                Spacer()
                Text(String(format: "%.0f ml", vm.brewParameters.waterAmountML))
                    .foregroundStyle(.secondary)
            }
            Slider(
                value: $vm.brewParameters.waterAmountML,
                in: Constants.Brew.waterRange,
                step: 5
            )

            // Brew ratio display
            HStack {
                Text("Brew Ratio")
                    .foregroundStyle(.secondary)
                Spacer()
                Text(String(format: "1:%.1f", vm.brewParameters.brewRatio))
                    .foregroundStyle(.secondary)
            }
            .font(.caption)

            // Temperature
            HStack {
                Text("Water Temp")
                Spacer()
                Text(String(format: "%.0f°C", vm.brewParameters.waterTempCelsius))
                    .foregroundStyle(.secondary)
            }
            Slider(
                value: $vm.brewParameters.waterTempCelsius,
                in: Constants.Brew.tempRange,
                step: 1
            )

            // Brew time
            HStack {
                Text("Brew Time")
                Spacer()
                Text(vm.brewParameters.brewTimeFormatted)
                    .foregroundStyle(.secondary)
            }
            Slider(
                value: Binding(
                    get: { Double(vm.brewParameters.brewTimeSeconds) },
                    set: { vm.brewParameters.brewTimeSeconds = Int($0) }
                ),
                in: Double(Constants.Brew.timeRange.lowerBound)...Double(Constants.Brew.timeRange.upperBound),
                step: 5
            )
        }
    }
}
