import SwiftUI

struct ShirtMachineView: View {
    @EnvironmentObject var wallet: StoreWallet
    
    let bagColor: Color = .blue
    
    private var pastelColor: Color {
        bagColor.opacity(0.2)
    }
    
    @State private var showingPopup = false
    @State private var machineOptions: [Machine] = []
    @State private var selectedMachineID: Machine.ID? = nil
    @State private var selectedMachine: Machine? = nil
    @State private var purchasedMachines: [Machine] = []
    @AppStorage("purchasedMachinesData") private var purchasedMachinesData: Data = Data()

    // ✅ FIXED PRICE
    private var computedPrice: Int {
        guard let selected = selectedMachine else { return 0 }
        
        let base = selected.number
        let multiplier = selected.age < 5 ? 1.2 : 0.9
        
        
        return Int(Double(base) * multiplier)
    }
    public func machineefficiency () -> Int {
        
        var totalefficiency: Int = 0
        
        for machine in purchasedMachines {
            totalefficiency = totalefficiency + machine.efficiency
        }
        return totalefficiency

        
    }

    private func savePurchasedMachines() {
        if let data = Machine.encode(purchasedMachines) {
            purchasedMachinesData = data
        }
    }

    private func loadPurchasedMachines() {
        guard !purchasedMachinesData.isEmpty else { return }
        purchasedMachines = Machine.decode(purchasedMachinesData)
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
                        .onChange(of: machine.upgradeLevel) { _ in
                            savePurchasedMachines()
                        }
                        .onChange(of: machine.condition) { _ in
                            savePurchasedMachines()
                        }
                    }
                }
            }
            .padding(.horizontal)

            Button(action: {
                showingPopup = true
                
                var options: [Machine] = []
                for _ in 0..<5 {
                    let number = Int.random(in: 1000...9999)
                    let age = Int.random(in: 0...20)
                    let base = Int.random(in: 80...140) // tweak range for balance
                    
                    let machine = Machine(
                        name: "Machine \(number)",
                        number: number,
                        age: age,
                        baseEfficiency: base
                    )
                    
                    options.append(machine)
                }
                
                machineOptions = options
                selectedMachine = options.first
                selectedMachineID = options.first?.id
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
        .onAppear {
            loadPurchasedMachines()
            // Ensure starting cash of $8000 if not already set/persisted
            if wallet.cash <= 0 {
                wallet.cash = 8000
            }
            // Seed a starter machine if the user has none
            if purchasedMachines.isEmpty {
                let starterNumber = 1000
                let starterAge = 0
                let starter = Machine(
                    name: "Machine \(starterNumber)",
                    number: starterNumber,
                    age: starterAge,
                    baseEfficiency: Int.random(in: 80...140)
                )
                purchasedMachines = [starter]
                savePurchasedMachines()
            }
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

                            // ✅ FIXED PICKER
                            Picker(selection: $selectedMachineID) {
                                ForEach(machineOptions) { option in
                                    Text("\(option.name) • base \(option.baseEfficiency) • \(option.efficiency) shirts/day • cond \(option.condition)% • age \(option.age)")
                                        .tag(Optional(option.id))
                                }
                            } label: {
                                Text(selectedMachine?.name ?? "Choose Machine")
                            }
                            .pickerStyle(.menu)
                            .onChange(of: selectedMachineID) { newID in
                                if let id = newID {
                                    selectedMachine = machineOptions.first(where: { $0.id == id })
                                } else {
                                    selectedMachine = nil
                                }
                            }

                            if let selected = selectedMachine {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(selected.name)
                                        .font(.subheadline)
                                        .bold()
                                        .foregroundStyle(bagColor)
                                    Text("\(selected.efficiency) shirts/day")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Text("Condition: \(selected.condition)%")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Text("Age: \(selected.age)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }

                            Text("Price: $\(computedPrice)")
                                .foregroundStyle(bagColor)

                            Spacer()

                            HStack {
                                Button("Cancel") {
                                    showingPopup = false
                                }

                                Spacer()

                                // ✅ FIXED CONFIRM + CLONING
                                Button("Confirm") {
                                    guard let selected = selectedMachine else { return }

                                    wallet.cash = max(0, wallet.cash - computedPrice)

                                    let newMachine = selected.clone()
                                    purchasedMachines.append(newMachine)
                                    savePurchasedMachines()

                                    showingPopup = false
                                }
                                .disabled(selectedMachineID == nil || wallet.cash < computedPrice)
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

// ✅ MACHINE CARD
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
                    // Persistence handled by parent via onChange
                }

                Button("Maintain") {
                    machine.condition = min(100, machine.condition + 10)
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

