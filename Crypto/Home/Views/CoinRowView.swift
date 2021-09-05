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
            symbol
            Spacer()
            if holdingIncluded {
                holdingValue
            }
            Spacer()
            price
        }
        .font(.subheadline)
    }
    
    private var symbol: some View {
        HStack {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(.theme.secondary)
            CoinImageView(coin)
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(.theme.accent)
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
            HStack(spacing: 3) {
                Image(systemName: "triangle.fill")
                    .rotationEffect(Angle(degrees: isPositiveChange ? 0 : 180))
                    .font(.caption2)
                Text("\(coin.priceChangePercentage24H.asPercentString)")
            }
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
