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

    private var coins: [CoinInfo] { store.searchText.isEmpty ? store.portfolioCoins : (store.coins ?? []) }
    
    var body: some View {
        NavigationView {
            VStack {
                coinsList
                SearchBarView(searchText: $store.searchText)
                selectedCoinInfo
                Spacer()
            }
            .background(Color.theme.background.ignoresSafeArea())
            .navigationTitle("Portfolio Editor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let coin = selectedCoin, let holding = Double(holdingInput) {
                        Button("Done") {
                            store.update(from: coin, holding: holding)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
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
    
    @State private var selectedCoin: CoinInfo?
    @State private var holdingInput = ""
    
    private var holdingValue: String {
        if let holding = Double(holdingInput), let price = selectedCoin?.currentPrice {
            return (holding * price).asCurrencyString
        }
        return ""
    }
    
    private var selectedCoinInfo: some View {
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
                TextField("e.g. 1.23", text: $holdingInput)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current Value: ")
                Spacer()
                Text(holdingValue)
            }
        }
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
