//
//  HomeStore.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-02.
//

import Foundation
import Combine

// TODO: should coins be optional?
class HomeStore: ObservableObject {
    @Published private(set) var coins: [CoinInfo]? // nil value: coins is loading
    @Published private(set) var portfolioCoins: [CoinInfo] = []
    @Published private(set) var statistics: [StatisticInfo] = []
    @Published private(set) var isDataReady = false
    @Published private(set) var isRefreshing = false
    @Published var searchText = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    private let marketDataService = CoinMarketDataService()
    private let globalDataService = GlobalDataService()
    private let portfolioDataManager = PortfolioDataManager.shared
    
    init() {
        // Verify whether necessary data (statistics and coins) are loaded
        $statistics.combineLatest($coins)
            .map { statistics, coins in
                !statistics.isEmpty && coins != nil
            }
            .assign(to: \.isDataReady, on: self)
            .store(in: &cancellables)
        
        // Updates coin infos in market
        marketDataService.$coins.combineLatest($searchText, $sortBy)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map { coins, searchText, sortBy -> [CoinInfo]? in
                guard var results = coins else { return nil }
                // filter by search query
                if !searchText.isEmpty {
                    let query = searchText.lowercased()
                    results = results.filter {
                        $0.id.lowercased().contains(query) || $0.name.lowercased().contains(query) || $0.symbol.lowercased().contains(query)
                    }
                }
                // sort coins
                switch(sortBy) {
                case .rankDesc:
                    results.sort { $0.marketCapRank < $1.marketCapRank }
                case .rankAsc:
                    results.sort { $0.marketCapRank > $1.marketCapRank }
                case .priceDesc:
                    results.sort { $0.currentPrice > $1.currentPrice }
                case .priceAsc:
                    results.sort { $0.currentPrice < $1.currentPrice }
                default:
                    break
                }
                return results
            }
            .sink { [weak self] results in
                self?.coins = results
                self?.isRefreshing = false
            }
            .store(in: &cancellables)
        
        // Updates coin infos in portfolio
        portfolioDataManager.$coins.combineLatest($coins)
            .map { [weak self] (entities, coins) -> [CoinInfo] in
                guard let self = self, var results = coins else { return [] }
                // TODO: Figure out better solution, this solution takes O(n*d) time (n: total coins, d: # of coins in portfolio)
                // convert `Coin` entities in CoreData into `CoinInfo`s
                results = results.compactMap { info in
                    if let entity = entities.first(where: { $0.id == info.id }) {
                        return info.updateHolding(to: entity.holding)
                    }
                    return nil
                }
                // sort portfolio coins
                switch self.sortBy {
                case .holdingDesc:
                    results.sort { $0.holdingValue > $1.holdingValue }
                case .holdingAsc:
                    results.sort { $0.holdingValue < $1.holdingValue }
                default:
                    break
                }
                return results
            }
            .assign(to: \.portfolioCoins, on: self)
            .store(in: &cancellables)
        
        // Updates global statistic data
        globalDataService.$globalData.combineLatest($portfolioCoins)
            .map { globalData, coins in
                guard let data = globalData else { return [] }
                // Global Data Statistics
                let marketCap = StatisticInfo(title: "MARKET CAP", value: data.marketCap, changePercentage: data.marketCapChangePercentage24HUsd)
                let volume = StatisticInfo(title: "24HR VOLUME", value: data.volume)
                let btcDominance = StatisticInfo(title: "BTC DOMINANCE", value: data.btcDominance)
                // TODO: The corner case when there is no coins in portfolio
                // Portfolio Statistics
                // current holding value in total
                let currentValue = coins
                    .map(\.holdingValue) // equivalent to .map { $0.holdingValue }
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
    
    // MARK: - Intent(s)
    
    func update(from info: CoinInfo, holding: Double) {
        portfolioDataManager.update(from: info, holding: holding)
    }
    
    func refresh() {
        isRefreshing = true
        marketDataService.fetchCoins()
        globalDataService.fetchGlobalData()
        HapticManager.notification(type: .success)
    }
    
    // MARK: - Sorting
    
    @Published var sortBy: SortBy = .rankDesc
    
    enum SortBy {
        case rankDesc, rankAsc
        case holdingDesc, holdingAsc
        case priceDesc, priceAsc
    }
}
