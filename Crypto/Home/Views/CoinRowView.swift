//
//  CoinRowView.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-02.
//

import SwiftUI

struct CoinRowView: View {
    let coin: CoinInfo
    
    private var isPositiveChange: Bool { coin.priceChangePercentage24H >= 0 }
    
    var body: some View {
        HStack {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(.theme.secondary)
            CoinImageView(coin)
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(.theme.accent)
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(coin.currentPrice.asCurrencyString)")
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
        .font(.subheadline)
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowView(coin: previewData.coin)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
