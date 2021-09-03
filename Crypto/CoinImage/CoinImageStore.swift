//
//  CoinImageStore.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-02.
//

import Foundation
import SwiftUI
import Combine

class CoinImageStore: ObservableObject {
    @Published var image: UIImage?
    private let coinImageService: CoinImageService
    private var cancellable: AnyCancellable?
    
    init(of coin: CoinInfo) {
        coinImageService = .init(for: coin)
        cancellable = coinImageService.$image
            .sink { [weak self] in self?.image = $0 }
    }
}
