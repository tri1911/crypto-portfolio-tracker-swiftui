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
    @State private var coinDetailsToShow: CoinInfo?
    
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
                    .fullScreenCover(item: $coinDetailsToShow) { coin in
                        CoinDetailsView(coin)
                    } // use fullScreenCover to present Details view rather than using NavigationLink to avoid HomeView loading all coins' details info at once
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
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
            .animation(.none)
            .overlay(CircleAnimationView(animate: $showsPortfolio))
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
            Button {
                withAnimation {
                    store.sortBy = (store.sortBy == .rankDesc) ? .rankAsc : .rankDesc
                }
            } label: {
                HStack(spacing: 2) {
                    Text("RANK")
                    Image(systemName: "chevron.down")
                        .imageScale(.small)
                        .rotationEffect(Angle(degrees: store.sortBy == .rankDesc ? 0 : 180))
                        .opacity((store.sortBy == .rankDesc || store.sortBy == .rankAsc) ? 1 : 0)
                }
            }
            .padding(.trailing, 35)
            
            Spacer()
            
            if showsPortfolio {
                Button {
                    withAnimation {
                        store.sortBy = (store.sortBy == .holdingDesc) ? .holdingAsc : .holdingDesc
                    }
                } label: {
                    HStack(spacing: 2) {
                        Text("HOLDINGS")
                        Image(systemName: "chevron.down")
                            .imageScale(.small)
                            .rotationEffect(Angle(degrees: store.sortBy == .holdingDesc ? 0 : 180))
                            .opacity((store.sortBy == .holdingDesc || store.sortBy == .holdingAsc) ? 1 : 0)
                    }
                }
            }
            
            Spacer()
            
            Button {
                withAnimation {
                    store.sortBy = (store.sortBy == .priceDesc) ? .priceAsc : .priceDesc
                }
            } label: {
                HStack(spacing: 2) {
                    Text("PRICE")
                    Image(systemName: "chevron.down")
                        .imageScale(.small)
                        .rotationEffect(Angle(degrees: store.sortBy == .priceDesc ? 0 : 180))
                        .opacity((store.sortBy == .priceDesc || store.sortBy == .priceAsc) ? 1 : 0)
                }
            }
            
//            Button {
//                withAnimation(.linear(duration: 1.0)) {
//                    store.refresh()
//                }
//            } label: {
//                Image(systemName: "goforward").imageScale(.large)
//            }
//            .rotationEffect(Angle(degrees: store.isRefreshing ? 360 : 0))
        }
        .font(.caption)
        .foregroundColor(.theme.secondary)
        .padding(.horizontal)
    }
    
    // TODO: might remove ProgressView and change coins in store to non-optional
    private var allCoinsList: some View {
        ZStack {
            if let coins = store.coins {
                List {
                    ForEach(coins) { coin in
                        Button {
                            coinDetailsToShow = coin
                        } label: {
                            CoinRowView(coin: coin)
                        }
                        .listRowBackground(Color.theme.background)
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
                        Button {
                            coinDetailsToShow = coin
                        } label: {
                            CoinRowView(coin: coin, holdingIncluded: true)
                        }
                        .listRowBackground(Color.theme.background)
                    }
                }
            }
        }
        .transition(.move(edge: .trailing))
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
