//
//  HomeStore.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-02.
//

import Foundation
import Combine

class HomeStore: ObservableObject {
    @Published var coins: [CoinInfo]? // nil indicates the coins is loading
    @Published var portfolioCoins: [CoinInfo] = []
    @Published var statistics: [StatisticInfo] = []
    @Published var searchText = ""
    @Published var isDataReady = false
    
    private let marketDataService = CoinMarketDataService()
    private let globalDataService = GlobalDataService()
    private let portfolioDataManager = PortfolioDataManager.shared
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // verify whether necessary data (statistics and coins) are loaded
        $statistics.combineLatest($coins)
            .map { statistics, coins in
                !statistics.isEmpty && coins != nil
            }
            .assign(to: \.isDataReady, on: self)
            .store(in: &cancellables)
        
        // Updates coin infos in market
        marketDataService.$coins.combineLatest($searchText)
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
            .assign(to: \.coins, on: self)
            .store(in: &cancellables)
        
        // TODO: Figure out better solution, this solution takes O(n*d) time (n: total coins, d: # of coins in portfolio)
        // Updates coin infos in portfolio
        portfolioDataManager.$coins.combineLatest($coins)
            .map { entities, coins -> [CoinInfo] in
                guard let coins = coins else { return [] }
                return coins.compactMap { info in
                    if let entity = entities.first(where: { $0.id == info.id }) {
                        return info.updateHolding(to: entity.holding)
                    }
                    return nil
                }
            }
            .assign(to: \.portfolioCoins, on: self)
            .store(in: &cancellables)
        
        // Updates global statistic data
        globalDataService.$result.combineLatest($portfolioCoins)
            .map { globalData, coins in
                guard let data = globalData else { return [] }
                // Global Data Statistics
                let marketCap = StatisticInfo(title: "Market Cap", value: data.marketCap, changePercentage: data.marketCapChangePercentage24HUsd)
                let volume = StatisticInfo(title: "24h Volume", value: data.volume)
                let btcDominance = StatisticInfo(title: "BTC Dominance", value: data.btcDominance)
                // TODO: The corner case when there is no coins in portfolio
                // Portfolio Statistics
                // current holding value in total
                let currentValue = coins
                    .map { $0.holdingValue }
                    .reduce(0, +)
                // previous holding value in total
                let previousValue = coins
                    .map { $0.holdingValue / (1 + $0.priceChangePercentage24H / 100) }
                    .reduce(0, +)
                let valueChangePercentage = (currentValue - previousValue) * 100 / previousValue
                let portfolio = StatisticInfo(title: "Portfolio Value", value: currentValue.asCurrencyString, changePercentage: valueChangePercentage)
                return [marketCap, volume, btcDominance, portfolio]
            }
            .assign(to: \.statistics, on: self)
            .store(in: &cancellables)
    }
    
    func update(from info: CoinInfo, holding: Double) {
        portfolioDataManager.update(from: info, holding: holding)
    }
}
