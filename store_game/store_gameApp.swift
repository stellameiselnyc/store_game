//
//  store_gameApp.swift
//  store game
//
//  Created by Stella Meisel on 2/25/26.
//

import SwiftUI

@main
struct store_gameApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(StoreWallet())
        }
    }
}
