import Foundation
import SwiftUI
import Combine

class Machine: ObservableObject, Identifiable {
    let id: UUID
    
    var name: String
    var number: Int
    
    @Published var age: Int
    @Published var upgradeLevel: Int
    @Published var condition: Int
    
    var baseEfficiency: Int = 100

    var efficiency: Int {
        let wearPenalty = (number * age) / 2
        let conditionFactor = Double(condition) / 100.0
        let doublingFactor = pow(2.0, Double(upgradeLevel)) // doubles per upgrade level

        let raw = Double(baseEfficiency - wearPenalty) * doublingFactor
        let adjusted = max(1.0, raw * conditionFactor)
        return Int(adjusted)
    }

    func ageMachine() {
        age += 1
        
        // older machines break down faster
        let extraWear = age / 2
        condition = max(0, condition - (5 + extraWear))
    }
    
    /// Returns a deep copy of this Machine with identical properties.
    func clone() -> Machine {
        let copy = Machine(name: self.name, number: self.number, age: self.age)
        copy.upgradeLevel = self.upgradeLevel
        copy.condition = self.condition
        return copy
    }
    
    struct Snapshot: Codable, Identifiable {
        let id: UUID
        let name: String
        let number: Int
        let age: Int
        let upgradeLevel: Int
        let condition: Int
    }

    func snapshot() -> Snapshot {
        Snapshot(id: self.id,
                 name: self.name,
                 number: self.number,
                 age: self.age,
                 upgradeLevel: self.upgradeLevel,
                 condition: self.condition)
    }

    convenience init(snapshot: Snapshot) {
        self.init(name: snapshot.name, number: snapshot.number, age: snapshot.age, id: snapshot.id)
        self.upgradeLevel = snapshot.upgradeLevel
        self.condition = snapshot.condition
    }
    
    // MARK: - Persistence helpers
    static func encode(_ machines: [Machine]) -> Data? {
        let snapshots = machines.map { $0.snapshot() }
        return try? JSONEncoder().encode(snapshots)
    }

    static func decode(_ data: Data) -> [Machine] {
        guard let snapshots = try? JSONDecoder().decode([Machine.Snapshot].self, from: data) else { return [] }
        return snapshots.map { Machine(snapshot: $0) }
    }
    
    init(name: String, number: Int, age: Int, id: UUID = UUID()) {
        self.id = id
        self.name = name
        self.number = number
        self.age = age
        self.upgradeLevel = 0
        self.condition = max(30, 100 - (age * 3))
    }
}

