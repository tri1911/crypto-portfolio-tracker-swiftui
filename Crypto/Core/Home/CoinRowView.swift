//
//  CoinRowView.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-02.
//

import SwiftUI

struct CoinRowView: View {
    let coin: CoinInfo
    
    var body: some View {
        HStack {
            Text("\(coin.rank)")
            // Image
            CoinImageView(coin).frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(coin.currentPrice.asCurrencyString)")
                Text("\(coin.priceChangePercentage24H.asPercentString)")
            }
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
