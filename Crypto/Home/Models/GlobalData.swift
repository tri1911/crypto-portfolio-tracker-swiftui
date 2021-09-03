//
//  GlobalData.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-02.
//

import Foundation

/*
 URL: https://api.coingecko.com/api/v3/global
 
 JSON Response:
 {
   "data": {
     "active_cryptocurrencies": 9221,
     "upcoming_icos": 0,
     "ongoing_icos": 50,
     "ended_icos": 3375,
     "markets": 639,
     "total_market_cap": {
       "btc": 46874251.08153671,
       "eth": 610437748.1314957,
       "ltc": 12451763047.497225,
       "bch": 3477356458.038405,
       "bnb": 4758536191.322638,
       "eos": 438943814415.1707,
       "xrp": 1822177226163.563,
       "xlm": 6428422629560.334,
       "link": 77650434419.23846,
       "dot": 69717168729.46738,
       "yfi": 60634112.82672826,
       "usd": 2323148935149.7417,
       "aed": 8532951593443.256,
       "ars": 227309204504406.6,
       "aud": 3130338648412.1943,
       "bdt": 197417851174558.38,
       "bhd": 875789978168.4879,
       "bmd": 2323148935149.7417,
       "brl": 12041577875561.646,
       "cad": 2913623699996.7505,
       "chf": 2123660136088.4329,
       "clp": 1787268170278748.8,
       "cny": 15005915916812.695,
       "czk": 49637389809855.64,
       "dkk": 14543404841611.607,
       "eur": 1955677882885.6243,
       "gbp": 1679037307687.9905,
       "hkd": 18056013001004.85,
       "huf": 681496279096727.9,
       "idr": 33123592689785756,
       "ils": 7441747630263.024,
       "inr": 169722997992510.6,
       "jpy": 255614528560825.12,
       "krw": 2687371077566941,
       "kwd": 698559269054.8518,
       "lkr": 462399603545736.25,
       "mmk": 3815085458913792.5,
       "mxn": 46380739230690.5,
       "myr": 9639906506403.846,
       "ngn": 954930369793301.2,
       "nok": 20087265241899.832,
       "nzd": 3261933419843.75,
       "php": 115779514565567.98,
       "pkr": 387674059109113.6,
       "pln": 8827501323781.996,
       "rub": 169277408734153.5,
       "sar": 8713959742725.462,
       "sek": 19910780263594.38,
       "sgd": 3118485942545.058,
       "thb": 75554202369194.83,
       "try": 19265874119196.797,
       "twd": 64338910491142.41,
       "uah": 62525388414747.59,
       "vef": 232616902876.5436,
       "vnd": 52786360152221544,
       "zar": 33549523032071.434,
       "xdr": 1634082052643.9102,
       "xag": 97022249765.89212,
       "xau": 1281518647.096651,
       "bits": 46874251081536.71,
       "sats": 4687425108153671
     },
     "total_volume": {
       "btc": 3116071.601560593,
       "eth": 40580226.61875437,
       "ltc": 827759043.1082288,
       "bch": 231165116.39937162,
       "bnb": 316334429.8554425,
       "eos": 29179780438.5306,
       "xrp": 121133342431.04852,
       "xlm": 427343898550.14886,
       "link": 5161987828.27998,
       "dot": 4634606091.971709,
       "yfi": 4030789.4570204765,
       "usd": 154436567112.79703,
       "aed": 567247209807.5396,
       "ars": 15110892240121.729,
       "aud": 208096324538.97385,
       "bdt": 13123797084588.844,
       "bhd": 58220114816.450516,
       "bmd": 154436567112.79703,
       "brl": 800491058315.7601,
       "cad": 193689709375.85654,
       "chf": 141175099094.8211,
       "clp": 118812684176888,
       "cny": 997552117951.6876,
       "czk": 3299757482909.6035,
       "dkk": 966805650678.3354,
       "eur": 130008099800.02892,
       "gbp": 111617793388.23686,
       "hkd": 1200314203462.5876,
       "huf": 45304002791822.45,
       "idr": 2201965559785913.8,
       "ils": 494706964305.55597,
       "inr": 11282719232275.988,
       "jpy": 16992552521194.834,
       "krw": 178649055813076.94,
       "kwd": 46438303547.98251,
       "lkr": 30739056943552.742,
       "mmk": 253616413740008,
       "mxn": 3083264287780.145,
       "myr": 640834535234.5507,
       "ngn": 63481150911715.2,
       "nok": 1335346279227.363,
       "nzd": 216844383883.07812,
       "php": 7696704460465.373,
       "pkr": 25771507776205.484,
       "pln": 586828067715.2065,
       "rub": 11253097680957.512,
       "sar": 579280134934.134,
       "sek": 1323614042096.9382,
       "sgd": 207308389173.5642,
       "thb": 5022636073090.125,
       "try": 1280742451066.4248,
       "twd": 4277074240782.198,
       "uah": 4156516268960.3726,
       "vef": 15463733465.004362,
       "vnd": 3509092391342262,
       "zar": 2230280240302.7437,
       "xdr": 108629291378.0373,
       "xag": 6449772961.473498,
       "xau": 85191843.51643215,
       "bits": 3116071601560.5933,
       "sats": 311607160156059.3
     },
     "market_cap_percentage": {
       "btc": 40.11783989314141,
       "eth": 19.23549392599961,
       "ada": 4.088992732320406,
       "bnb": 3.2471547902833873,
       "usdt": 2.8493348148654727,
       "xrp": 2.551602945340357,
       "sol": 1.7373718326615832,
       "doge": 1.6636694425053107,
       "dot": 1.4728732813265388,
       "usdc": 1.1881502617414257
     },
     "market_cap_change_percentage_24h_usd": 1.0256911817052052,
     "updated_at": 1630649839
   }
 }
 */

struct GlobalDataResponse: Codable {
    let data: GlobalData?
}

struct GlobalData: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String:Double]
    let marketCapChangePercentage24HUsd: Double

    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap: String {
        if let marketCapInUSD = totalMarketCap.first(where: { $0.key == "usd" }) {
            return "$" + marketCapInUSD.value.formattedWithAbbreviations
        }
        return ""
    }
    
    var volume: String {
        if let totalVolumeInUSD = totalVolume.first(where: { $0.key == "usd" }) {
            return "$" + totalVolumeInUSD.value.formattedWithAbbreviations
        }
        return ""
    }
    
    var btcDominance: String {
        if let btcItem = marketCapPercentage.first(where: { $0.key == "btc" }) {
            return btcItem.value.asPercentString
        }
        return ""
    }
}
