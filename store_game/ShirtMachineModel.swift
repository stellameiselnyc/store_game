import Foundation
import SwiftUI
import Combine

@MainActor
final class ShirtMachineModel: ObservableObject {
    // Persisted shirts-per-day value so it survives app restarts
    @AppStorage("machineShirtsPerDay") private var persistedShirtsPerDay: Int = 0

    // Published value to update views
    @Published var shirtsPerDay: Int = 0 {
        didSet { persistedShirtsPerDay = shirtsPerDay }
    }

    init() {
        // Load from persistence on startup
        shirtsPerDay = max(0, persistedShirtsPerDay)
        if shirtsPerDay == 0 {
            // Default starting efficiency: random 10...40 shirts/day
            shirtsPerDay = Int.random(in: 10...40)
            persistedShirtsPerDay = shirtsPerDay
        }
    }

    func setInitialIfNeeded(_ value: Int) {
        if shirtsPerDay == 0 {
            let initial = Int.random(in: 10...40)
            shirtsPerDay = initial
            persistedShirtsPerDay = initial
        }
    }
}
