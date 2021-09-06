//
//  CoinDetailsService.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-04.
//

import Foundation
import Combine

class CoinDetailsService {
    @Published private(set) var coinDetails: CoinDetails?
    
    private var cancellable: AnyCancellable?
    
    init(_ coin: CoinInfo) {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }
        cancellable?.cancel()
        cancellable = NetworkingManager.fetch(url)
            .decode(type: CoinDetails.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] result in
                self?.coinDetails = result
            }
    }
}
