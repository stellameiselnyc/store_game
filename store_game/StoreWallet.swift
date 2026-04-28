import Foundation
import SwiftUI
import Combine

final class StoreWallet: ObservableObject {
    @Published var cash: Int

    init(cash: Int = 8000) {
        self.cash = cash
    }
}

