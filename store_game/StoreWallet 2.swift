import Foundation
import Combine

final class StoreWallet: ObservableObject {
    @Published var cash: Int {
        didSet {
            UserDefaults.standard.set(cash, forKey: "availableCash")
        }
    }

    init(cash: Int = UserDefaults.standard.integer(forKey: "availableCash")) {
        // Default to 8000 if nothing persisted yet
        self.cash = cash == 0 ? 8000 : cash
    }
}
