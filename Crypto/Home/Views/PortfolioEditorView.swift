//
//  PortfolioEditorView.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-03.
//

import SwiftUI

struct PortfolioEditorView: View {
    @EnvironmentObject var store: HomeStore
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCoin: CoinInfo?
    @State private var holdingText = ""
    
    private var coins: [CoinInfo] { store.searchText.isEmpty ? store.portfolioCoins : (store.coins ?? []) }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    SearchBarView(searchText: $store.searchText)
                    coinsList
                    if selectedCoin != nil {
                        inputView
                    }
                    Spacer()
                }
            }
            .background(Color.theme.background.ignoresSafeArea())
            .navigationTitle("Add Coin")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    // TODO: holding property of portfolio coin from global listis not in sync with the one in the portfolio list
                    // so, Save button still show even when the portfolio coin's holding does not change
                    if let coin = selectedCoin, let holding = Double(holdingText), holding != coin.holding {
                        Button("Save") {
                            store.update(from: coin, holding: holding)
                            selectedCoin = nil
                            UIApplication.shared.endEditing()
                        }
                    }
                }
            }
            .onChange(of: store.searchText) { text in
                if text.isEmpty {
                    selectedCoin = nil
                }
            }
        }
    }
    
    private var coinsList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(coins) { coin in
                    Button {
                        withAnimation {
                           selectedCoin = coin
                            if let portfolioCoin = store.portfolioCoins.first(where: { $0.id == coin.id }),
                               let currentHolding = portfolioCoin.holding {
                                holdingText = String(currentHolding)
                            } else {
                                holdingText = ""
                            }
                        }
                    } label: {
                        CoinLogoView(coin: coin)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(selectedCoin?.id == coin.id ? Color.theme.green : .clear, lineWidth: 2.0)
                    )
                }
            }
            .padding()
            .frame(height: 150)
        }
    }
    
    private var currentHoldingValue: String {
        if let holding = Double(holdingText), let price = selectedCoin?.currentPrice {
            return (holding * price).asCurrencyString
        }
        return ""
    }
    
    private var inputView: some View {
        VStack {
            HStack {
                Text("Current Price: ")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyString ?? "")
            }
            Divider()
            HStack {
                Text("Holding Amount: ")
                Spacer()
                TextField("e.g. 1.23", text: $holdingText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current Value: ")
                Spacer()
                Text(currentHoldingValue)
            }
        }
        .padding()
        .font(.headline)
    }
}

struct CoinLogoView: View {
    let coin: CoinInfo
    
    var body: some View {
        VStack {
            CoinImageView(coin)
                .frame(width: 50, height: 50)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(coin.name)
                .font(.caption)
                .foregroundColor(.theme.secondary)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
        .frame(width: 60)
        .padding(10)
    }
}

struct PortfolioEditorView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioEditorView()
            .environmentObject(previewData.homeStore)
            .preferredColorScheme(.dark)
//        CoinLogoView(coin: previewData.coin)
//            .preferredColorScheme(.dark)
//            .previewLayout(.sizeThatFits)
//            .padding()
    }
}
