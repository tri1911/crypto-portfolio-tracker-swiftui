//
//  CoinImageView.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-02.
//

import SwiftUI

struct CoinImageView: View {
    @StateObject private var imageStore: CoinImageStore
    
    init(_ coin: CoinInfo) {
        _imageStore = .init(wrappedValue: CoinImageStore(of: coin))
    }
    
    var body: some View {
        if let image = imageStore.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else {
            ProgressView()
        }
    }
}

struct CoinLogoView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(previewData.coin)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
