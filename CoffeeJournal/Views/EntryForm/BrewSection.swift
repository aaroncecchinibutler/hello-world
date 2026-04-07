import SwiftUI

struct BrewSection: View {
    @Bindable var vm: EntryFormViewModel

    var body: some View {
        FormSection(title: "Brew") {
            FormRow(label: "Method") {
                Spacer()
                Picker("", selection: $vm.brewMethod) {
                    ForEach(BrewMethod.allCases) { m in Text(m.displayName).tag(m) }
                }
                .tint(Color.textSecondary)
            }

            FormRow(label: "Grind Size") {
                Spacer()
                Picker("", selection: $vm.brewParameters.grindSize) {
                    ForEach(GrindSize.allCases) { s in Text(s.displayName).tag(s) }
                }
                .tint(Color.textSecondary)
            }

            FormRow(label: "Grind Setting") {
                Spacer()
                TextField("Optional", value: $vm.brewParameters.grindNumeric, format: .number)
                    .font(Constants.Typography.body)
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .frame(width: 80)
            }

            sliderRow(
                label: "Dose",
                valueText: String(format: "%.1f g", vm.brewParameters.dosageGrams),
                value: $vm.brewParameters.dosageGrams,
                range: Constants.Brew.doseRange,
                step: 0.5
            )

            sliderRow(
                label: "Water",
                valueText: String(format: "%.0f ml", vm.brewParameters.waterAmountML),
                value: $vm.brewParameters.waterAmountML,
                range: Constants.Brew.waterRange,
                step: 5
            )

            FormRow {
                Text("Ratio")
                    .font(Constants.Typography.body)
                    .foregroundStyle(Color.textPrimary)
                Spacer()
                Text(String(format: "1:%.1f", vm.brewParameters.brewRatio))
                    .font(Constants.Typography.mono)
                    .foregroundStyle(Color.textTertiary)
            }

            sliderRow(
                label: "Temp",
                valueText: String(format: "%.0f°C", vm.brewParameters.waterTempCelsius),
                value: $vm.brewParameters.waterTempCelsius,
                range: Constants.Brew.tempRange,
                step: 1
            )

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Time")
                        .font(Constants.Typography.body)
                        .foregroundStyle(Color.textPrimary)
                    Spacer()
                    Text(vm.brewParameters.brewTimeFormatted)
                        .font(Constants.Typography.mono)
                        .foregroundStyle(Color.textSecondary)
                }
                Slider(
                    value: Binding(
                        get: { Double(vm.brewParameters.brewTimeSeconds) },
                        set: { vm.brewParameters.brewTimeSeconds = Int($0) }
                    ),
                    in: Double(Constants.Brew.timeRange.lowerBound)...Double(Constants.Brew.timeRange.upperBound),
                    step: 5
                )
                .tint(Color.appAccent)
            }
            .padding(.horizontal, Constants.Layout.pageInset)
            .padding(.vertical, 11)
            .overlay(
                Rectangle().fill(Color.appBorder).frame(height: Constants.Layout.borderWidth),
                alignment: .bottom
            )
        }
    }

    private func sliderRow(
        label: String,
        valueText: String,
        value: Binding<Double>,
        range: ClosedRange<Double>,
        step: Double
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .font(Constants.Typography.body)
                    .foregroundStyle(Color.textPrimary)
                Spacer()
                Text(valueText)
                    .font(Constants.Typography.mono)
                    .foregroundStyle(Color.textSecondary)
            }
            Slider(value: value, in: range, step: step)
                .tint(Color.appAccent)
        }
        .padding(.horizontal, Constants.Layout.pageInset)
        .padding(.vertical, 11)
        .overlay(
            Rectangle().fill(Color.appBorder).frame(height: Constants.Layout.borderWidth),
            alignment: .bottom
        )
    }
}
