//
//  CoinMarketDataService.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-02.
//

import Foundation
import Combine

class CoinMarketDataService
{
    @Published var coins: [CoinInfo]?
    private var cancellable: AnyCancellable?
    
    init() {
        fetchCoins()
    }
    
    func fetchCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
        cancellable = NetworkingManager.fetch(url)
            .decode(type: [CoinInfo].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] results in
                self?.coins = results
                self?.cancellable?.cancel()
            }
    }
}
