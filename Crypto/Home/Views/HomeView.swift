//
//  HomeView.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-02.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: HomeStore
    @State private var showsPortfolio = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // background
                Color.theme.background
                    .ignoresSafeArea()
                    .sheet(isPresented: $showsPortfolioEditor) {
                        PortfolioEditorView()
                            .environmentObject(store)
                    }
                
                // main content
                if !store.isDataReady {
                    LoadingView()
                } else {
                    VStack {
                        header
                        
                        HomeStatsView(showsPortfolio: $showsPortfolio)
                        
                        SearchBarView(searchText: $store.searchText)
                        
                        columnTitles
                        
                        if !showsPortfolio {
                            allCoinsList
                        }
                        
                        if showsPortfolio {
                            portfolioCoinsList
                        }
                        
                        Spacer()
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarHidden(true)
            .ignoresSafeArea(edges: .bottom)
        }
    }
    
    @State private var showsPortfolioEditor = false
    
    private var header: some View {
        HStack {
            AnimatedCircleButton(imageName: showsPortfolio ? "plus" : "info") {
                if showsPortfolio {
                    showsPortfolioEditor = true
                }
            }
            Spacer()
            Text(showsPortfolio ? "Portfolio" : "Live Prices")
                .fontWeight(.heavy)
            Spacer()
            AnimatedCircleButton(imageName: "chevron.right") {
                showsPortfolio.toggle()
            }
            .rotationEffect(Angle(degrees: showsPortfolio ? 180 : 0))
        }
        .font(.headline)
        .foregroundColor(.theme.accent)
        .padding(.vertical)
        .padding(.horizontal, 20)
    }
    
    private var columnTitles: some View {
        HStack {
            Text("Coin")
            Spacer()
            if showsPortfolio {
                Text("Holding")
            }
            Spacer()
            Text("Price")
        }
        .font(.caption)
        .foregroundColor(.theme.secondary)
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View {
        ZStack {
            if let coins = store.coins {
                List {
                    ForEach(coins) { coin in
                        CoinRowView(coin: coin)
                    }
                }
            } else {
                ProgressView()
                    .scaleEffect(2)
                    .padding()
            }
        }
        .transition(.move(edge: .leading))
    }
    
    private var portfolioCoinsList: some View {
        ZStack {
            if store.portfolioCoins.isEmpty {
                Text("Add your first coins by clicking on + button.")
                    .font(.callout)
                    .foregroundColor(.theme.accent)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding(50)
            } else {
                List {
                    ForEach(store.portfolioCoins) { coin in
                        CoinRowView(coin: coin)
                    }
                }
            }
        }
        .transition(.move(edge: .trailing))
    }
}

struct AnimatedCircleButton: View {
    var imageName: String
    var action: () -> Void
    
    var body: some View {
        Button {
            withAnimation(.spring()) {
                action()
            }
        } label: {
            Image(systemName: imageName)
                .frame(width: 50, height: 50)
                .background(Color.theme.background)
                .clipShape(Circle())
                .shadow(color: .theme.accent, radius: 10, x: 0.0, y: 0.0)
            //.padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
            .environmentObject(previewData.homeStore)
//        AnimatedCircleButton(imageName: "plus") {}
//            .previewLayout(.sizeThatFits)
//            .preferredColorScheme(.dark)
//            .padding()
    }
}
