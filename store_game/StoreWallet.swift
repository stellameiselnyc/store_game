import Foundation
import SwiftUI

final class StoreWallet: ObservableObject {
    @Published var cash: Int

    init(cash: Int = 1000) {
        self.cash = cash
    }
}
