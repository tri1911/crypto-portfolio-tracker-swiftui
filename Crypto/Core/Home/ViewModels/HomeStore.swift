//
//  HomeStore.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-02.
//

import Foundation
import Combine

class HomeStore: ObservableObject {
    @Published var coins: [CoinInfo]?
    @Published var statistics: [StatisticInfo] = []
    
    private let marketDataService = CoinMarketDataService()
    private let globalDataService = GlobalDataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Updates market data
        marketDataService.$coins
            .sink { [weak self] results in
                self?.coins = results
            }
            .store(in: &cancellables)
        
        // Updates global data
        globalDataService.$result
            .map { globalData -> [StatisticInfo] in
                guard let data = globalData else { return [] }
                let marketCap = StatisticInfo(title: "Market Cap", value: data.marketCap, changePercentage: data.marketCapChangePercentage24HUsd)
                let volume = StatisticInfo(title: "24h Volume", value: data.volume)
                let btcDominance = StatisticInfo(title: "BTC Dominance", value: data.btcDominance)
                return [marketCap, volume, btcDominance]
            }
            .sink { [weak self] in self?.statistics = $0 }
            .store(in: &cancellables)
    }
}
