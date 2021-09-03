//
//  HomeView.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-02.
//

import SwiftUI

struct HomeView: View {
    @StateObject var homeVM = HomeViewModel()
    
    var body: some View {
        NavigationView {
            if let coins = homeVM.coins {
                VStack {
                    header
                    List {
                        ForEach(coins) { coin in
                            CoinRowView(coin: coin)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                .padding()
                .navigationBarHidden(true)
            } else {
                ProgressView()
            }
        }
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
