//
//  CoinInfo.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-02.
//



import Foundation

// CoinGecko API: https://www.coingecko.com/en/api/documentation
// Website for convert JSON to Swift data structure: https://app.quicktype.io/

/*
 URL: https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h
 
 JSON Response:
 {
     "id": "bitcoin",
     "symbol": "btc",
     "name": "Bitcoin",
     "image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
     "current_price": 48608,
     "market_cap": 914068671522,
     "market_cap_rank": 1,
     "fully_diluted_valuation": 1020774888397,
     "total_volume": 39480104670,
     "high_24h": 50212,
     "low_24h": 48480,
     "price_change_24h": -1102.783661118992,
     "price_change_percentage_24h": -2.21838,
     "market_cap_change_24h": -15292161764.427002,
     "market_cap_change_percentage_24h": -1.64545,
     "circulating_supply": 18804775,
     "total_supply": 21000000,
     "max_supply": 21000000,
     "ath": 64805,
     "ath_change_percentage": -25.13676,
     "ath_date": "2021-04-14T11:54:46.763Z",
     "atl": 67.81,
     "atl_change_percentage": 71446.42589,
     "atl_date": "2013-07-06T00:00:00.000Z",
     "roi": null,
     "last_updated": "2021-09-03T01:49:35.707Z",
     "sparkline_in_7d": {
       "price": [
         47229.070650876114,
         47004.53470834667
       ]
     },
     "price_change_percentage_24h_in_currency": -2.2183846304166956
   }
 */

struct CoinInfo: Identifiable, Codable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap, marketCapRank, fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double
    let priceChange24H: Double
    let priceChangePercentage24H: Double
    let marketCapChange24H: Double?
    let marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    let priceChangePercentage24HInCurrency: Double?
    var holding: Double? // Custom stored property that is used in portfolio page
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
        case holding
    }
    
    func updateHolding(to amount: Double) -> CoinInfo {
        var newInfo = self
        newInfo.holding = amount
        return newInfo
    }
    
    var holdingValue: Double {
        (holding ?? 0) * currentPrice
    }
    
    var rank: Int {
        Int(marketCapRank ?? 0)
    }
}

struct SparklineIn7D: Codable {
    let price: [Double]?
}
