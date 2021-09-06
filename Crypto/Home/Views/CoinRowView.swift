//
//  CoinRowView.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-02.
//

import SwiftUI

struct CoinRowView: View {
    let coin: CoinInfo
    var holdingIncluded = false
    
    private var isPositiveChange: Bool { coin.priceChangePercentage24H >= 0 }
    
    var body: some View {
        HStack {
            name
            Spacer()
            if holdingIncluded {
                holdingValue
            }
            Spacer()
            price
        }
        .font(.subheadline)
    }
    
    private var name: some View {
        HStack {
            Text("\(coin.marketCapRank)")
                .font(.caption)
                .foregroundColor(.theme.secondary)
                .padding(.trailing, 6)
            CoinImageView(coin)
                .frame(width: 30, height: 30)
            VStack(alignment: .leading) {
                Text(coin.symbol.uppercased())
                    .font(.headline)
                    .foregroundColor(.theme.accent)
                Text(coin.name)
                    .font(.caption)
                    .foregroundColor(.theme.secondary)
                    .lineLimit(1)
            }
        }
    }
    
    private var holdingValue: some View {
        VStack(alignment: .trailing) {
            Text("\(coin.holdingValue.asCurrencyString)")
                .bold()
                .foregroundColor(.theme.accent)
            Text("\(String(format: "%.2f", coin.holding ?? 0))")
                .foregroundColor(.theme.secondary)
        }
    }
    
    private var price: some View {
        VStack(alignment: .trailing) {
            Text("\(coin.currentPrice.asCurrencyString)")
                .bold()
                .foregroundColor(.theme.accent)
            Text("\(isPositiveChange ? "+" : "")" + coin.priceChangePercentage24H.asPercentString)
                .font(.caption)
                .foregroundColor(isPositiveChange ? .theme.green : .theme.red)
        }
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowView(coin: previewData.coin)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
