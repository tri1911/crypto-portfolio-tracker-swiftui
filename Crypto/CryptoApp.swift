//
//  CryptoApp.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-02.
//

import SwiftUI

// TODO: Replace Launch Screen (instead of Loading View)

@main
struct CryptoApp: App {
    @StateObject var store = HomeStore()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(store)
        }
    }
}
