//
//  CoinDetailsStore.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-04.
//

import Foundation
import Combine

class CoinDetailsStore: ObservableObject {
    @Published private(set) var overviewStats: [StatisticInfo] = []
    @Published private(set) var additionalStats: [StatisticInfo] = []
    @Published private(set) var description = ""
    @Published private(set) var homepage: String?
    @Published private(set) var subredditURL: String?
    @Published private(set) var coinInfo: CoinInfo
    
    private let coinDetailsService: CoinDetailsService
    private var cancellables = Set<AnyCancellable>()
    
    init(_ info: CoinInfo) {
        coinInfo = info
        coinDetailsService = .init(info)
        
        // update overview & additional stats.
        coinDetailsService.$coinDetails.combineLatest($coinInfo)
            .map { (details, info) -> (overview: [StatisticInfo], additional: [StatisticInfo]) in
                // overview
                let currentPrice = StatisticInfo(title: "Current Price", value: info.currentPrice.asCurrencyString, changePercentage: info.priceChangePercentage24H)
                let marketCap = StatisticInfo(title: "Market Capitalization", value: info.marketCap.formattedWithAbbreviations, changePercentage: info.marketCapChangePercentage24H)
                let rank = StatisticInfo(title: "Rank", value: "#\(info.marketCapRank)")
                let volume = StatisticInfo(title: "Volume", value: info.totalVolume.formattedWithAbbreviations)
                let overview = [currentPrice, marketCap, rank, volume]
                // additional
                let high = StatisticInfo(title: "24h High", value: info.high24H.asCurrencyString)
                let low = StatisticInfo(title: "24h Low", value: info.low24H.asCurrencyString)
                let priceChange = StatisticInfo(title: "24h Price Change", value: info.priceChange24H.asCurrencyString, changePercentage: info.priceChangePercentage24H)
                let marketCapChange = StatisticInfo(title: "24h Market Cap Change", value: info.marketCapChange24H.formattedWithAbbreviations, changePercentage: info.marketCapChangePercentage24H)
                let blockTime = StatisticInfo(title: "Block Time (in mins)", value: "\(details?.blockTimeInMinutes ?? 0)")
                let hashAlgorithm = StatisticInfo(title: "Hashing Algorithm", value: details?.hashingAlgorithm ?? "n/a")
                let additional = [high, low, priceChange, marketCapChange, blockTime, hashAlgorithm]
                return (overview: overview, additional: additional)
            }
            .sink { [weak self] result in
                self?.overviewStats = result.overview
                self?.additionalStats = result.additional
            }
            .store(in: &cancellables)
        
        // update description, links
        coinDetailsService.$coinDetails
            .sink { [weak self] result in
                guard let self = self, let details = result else { return }
                self.description = details.readableDescription
                self.homepage = details.links?.homepage?.first
                self.subredditURL = details.links?.subredditURL
            }
            .store(in: &cancellables)
    }
}
