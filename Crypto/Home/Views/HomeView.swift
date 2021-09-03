//
//  HomeView.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-02.
//

import SwiftUI

struct HomeView: View {
    @StateObject var store = HomeStore()
    
    private var coins: [CoinInfo]? { store.coins }
    
    var body: some View {
        NavigationView {
            VStack {
                header
                HomeStatsView()
                SearchBarView(searchText: $store.searchText)
                coinsList
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
        .environmentObject(store)
    }
    
    var header: some View {
        HStack {
            AnimatedButton(imageName: "info")
            Spacer()
            Text("Live Prices")
            Spacer()
            AnimatedButton(imageName: "chevron.forward")
        }
    }
    
    var coinsList: some View {
        Group {
            if let coins = coins {
                List {
                    ForEach(coins) { coin in
                        CoinRowView(coin: coin)
                    }
                }
                .listStyle(PlainListStyle())
            } else {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
            }
        }
    }
}

struct AnimatedButton: View {
    var imageName: String
    
    var body: some View {
        Button {
            
        } label: {
            Image(systemName: imageName)
                .frame(width: 50, height: 50)
                .background(Color.theme.background)
                .clipShape(Circle())
                .shadow(color: .theme.accent, radius: 10, x: 0.0, y: 0.0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
    }
}
