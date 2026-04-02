import Foundation
import SwiftUI
import Combine

class Machine: ObservableObject, Identifiable {
    let id = UUID()
    
    var name: String
    var number: Int
    
    @Published var age: Int
    @Published var upgradeLevel: Int
    @Published var condition: Int
    
    var baseEfficiency: Int = 100

    var efficiency: Int {
        let wearPenalty = (number * age) / 2
        let upgradeBonus = upgradeLevel * 10
        let conditionFactor = Double(condition) / 100.0
        
        let raw = baseEfficiency - wearPenalty + upgradeBonus
        return max(1, Int(Double(raw) * conditionFactor))
    }

    func ageMachine() {
        age += 1
        
        // older machines break down faster
        let extraWear = age / 2
        condition = max(0, condition - (5 + extraWear))
    }
    
    init(name: String, number: Int, age: Int) {
        self.name = name
        self.number = number
        self.age = age
        self.upgradeLevel = 0
        self.condition = max(30, 100 - (age * 3))
    }
}
