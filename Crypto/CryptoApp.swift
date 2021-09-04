//
//  CryptoApp.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-02.
//

import SwiftUI

@main
struct CryptoApp: App {
    @StateObject var store = HomeStore()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(store)
        }
    }
}
