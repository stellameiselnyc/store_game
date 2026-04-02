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
    
    @State private var purchasedMachines: [Machine] = []

    private var computedPrice: Int {
        guard let selected = selectedMachine else { return 0 }
        let parts = selected.split(separator: " ")
        let number = parts.compactMap { Int($0) }.first ?? 0
        let isNew = selected.contains("(new)")
        let multiplier: Double = isNew ? 1.2 : 0.9
        return Int(Double(number) * multiplier)
    }

    var body: some View {
        VStack {
            VStack(spacing: 12) {
                HStack {
                    Text("Shirt Machines")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }

                if purchasedMachines.isEmpty {
                    Text("No machines yet")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(purchasedMachines) { machine in
                        MachineCard(
                            machine: machine,
                            bagColor: bagColor,
                            pastelColor: pastelColor
                        )
                    }
                }
            }
            .padding(.horizontal)

            Button(action: {
                showingPopup = true
                
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
            .clipShape(RoundedRectangle(cornerRadius: 12))
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

                            Text("Price: $\(computedPrice)")
                                .foregroundStyle(bagColor)

                            Spacer()

                            HStack {
                                Button("Cancel") {
                                    showingPopup = false
                                }

                                Spacer()

                                Button("Confirm") {
                                    wallet.cash = max(0, wallet.cash - computedPrice)

                                    if let selected = selectedMachine {
                                        let parts = selected.split(separator: " ")
                                        let number = parts.compactMap { Int($0) }.first ?? 1000
                                        let isNew = selected.contains("(new)")
                                        
                                        let age = isNew ? 1 : Int.random(in: 5...15)
                                        
                                        let machine = Machine(
                                            name: "Machine \(number)",
                                            number: number,
                                            age: age
                                        )
                                        
                                        purchasedMachines.append(machine)
                                    }

                                    showingPopup = false
                                }
                                .disabled(selectedMachine == nil)
                            }
                        }
                        .frame(width: 300, height: 350)
                        .padding()
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
            }
        )
    }
}
private struct MachineCard: View {
    @ObservedObject var machine: Machine
    
    let bagColor: Color
    let pastelColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(machine.name)
                .font(.headline)
                .foregroundStyle(bagColor)

            Text("\(machine.efficiency) shirts/day")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("Condition: \(machine.condition)%")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text("Age: \(machine.age)")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack {
                Button("Upgrade") {
                    machine.upgradeLevel += 1
                }

                Button("Maintain") {
                    machine.condition = 100
                }
            }
            .font(.caption)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(pastelColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
#Preview {
    ShirtMachineView()
        .environmentObject(StoreWallet(cash: 1000))
}
