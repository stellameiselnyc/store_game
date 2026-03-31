//
//  ShirtView.swift
//  store_game
//
//  Created by Stella Meisel on 3/19/26.
//

import SwiftUI

struct ShirtMachineView: View {
    @EnvironmentObject var wallet: StoreWallet
    let bagColor: Color = .blue
    private var pastelColor: Color {
        bagColor.opacity(0.2)
    }
    @State private var showingPopup = false
    @State private var machineOptions: [String] = []
    @State private var selectedMachine: String? = nil
    @State private var purchasedMachines: [String] = []

    private var computedPrice: Int {
        guard let selected = selectedMachine else { return 0 }
        // Expected format: "Machine XXXX (new)" or "Machine XXXX (old)"
        let parts = selected.split(separator: " ")
        // Try to find the numeric component
        let number = parts.compactMap { Int($0) }.first ?? 0
        let isNew = selected.contains("(new)")
        // Base price proportional to number, scaled down
        let base = number
        // Apply a multiplier for new vs old
        let multiplier: Double = isNew ? 1.2 : 0.9
        return Int(Double(base) * multiplier)
    }

    var body: some View {
        VStack{
            VStack(spacing: 12) {
                // Render a card for each purchased machine; if none, show the original default card
                HStack {
                    Text("Shirt Machines")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }
               
                if purchasedMachines.isEmpty {
                    MachineCard(title: "Machine 1000", subtitle: selectedMachine, bagColor: bagColor, pastelColor: pastelColor)
                } else {
                    ForEach(purchasedMachines, id: \.self) { machine in
                        MachineCard(title: machine.components(separatedBy: " (").first ?? machine, subtitle: machine, bagColor: bagColor, pastelColor: pastelColor)
                    }
                }
            }
            .padding(.horizontal)

            Button(action: {
                showingPopup = true
                // Generate a few random machine labels like "Machine 1234 (new)" or "Machine 5678 (old)"
                var options: [String] = []
                for _ in 0..<5 {
                    let number = Int.random(in: 1000...9999)
                    let isNew = Bool.random()
                    let label = "Machine \(number) (\(isNew ? "new" : "old"))"
                    options.append(label)
                }
                machineOptions = options
                selectedMachine = options.first
            }) {
                Text("Buy New Machine")
                    .font(.headline)
                    .foregroundStyle(bagColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(pastelColor)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .padding(.horizontal)
            Spacer()
        }
        .overlay(
            Group {
                if showingPopup {
                    ZStack {
                        Color.black.opacity(0.2)
                            .ignoresSafeArea()
                        VStack(spacing: 20) {
                            Text("Buy Machine")
                                .font(.headline)
                                .foregroundStyle(bagColor)

                            Picker("Choose Machine", selection: Binding(
                                get: { selectedMachine ?? "" },
                                set: { selectedMachine = $0.isEmpty ? nil : $0 }
                            )) {
                                ForEach(machineOptions, id: \.self) { option in
                                    Text(option).tag(option)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(bagColor)

                            Text("Price: $\(computedPrice)")
                                .font(.headline)
                                .foregroundStyle(bagColor)

                            Spacer()

                            HStack {
                                Button("Cancel") { showingPopup = false }
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Button("Confirm") {
                                    // Subtract price from available cash
                                    wallet.cash = max(0, wallet.cash - computedPrice)
                                    if let selected = selectedMachine {
                                        purchasedMachines.append(selected)
                                    }
                                    showingPopup = false
                                }
                                .disabled(selectedMachine == nil)
                                .foregroundStyle(bagColor)
                            }
                            .padding(.top, 8)
                        }
                        .frame(minWidth: 280, maxWidth: 320, minHeight: 360)
                        .padding(20)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .shadow(radius: 10)
                        .padding(.horizontal, 24)
                    }
                    .transition(.opacity)
                    .animation(.easeInOut, value: showingPopup)
                }
            }
        )
    }
}

private struct MachineCard: View {
    let title: String
    let subtitle: String?
    let bagColor: Color
    let pastelColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundStyle(bagColor)
            if let subtitle, !subtitle.isEmpty {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(pastelColor)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

#Preview {
    ShirtMachineView()
        .environmentObject(StoreWallet(cash: 1000))
}
