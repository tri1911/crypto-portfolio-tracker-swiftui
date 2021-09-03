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
    @Published var searchText = ""
    
    private let marketDataService = CoinMarketDataService()
    private let globalDataService = GlobalDataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Updates market data (based on the searchText as well)
        marketDataService.$coins
            .combineLatest($searchText)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map { coins, searchText -> [CoinInfo]? in
                if !searchText.isEmpty {
                    let query = searchText.lowercased()
                    return coins?.filter {
                        $0.id.lowercased().contains(query) || $0.name.lowercased().contains(query) || $0.symbol.lowercased().contains(query)
                    }
                }
                return coins
            }
            .sink { [weak self] results in
                self?.coins = results
            }
            .store(in: &cancellables)
        
        // Updates global data
        globalDataService.$result
            .map { globalData in
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
