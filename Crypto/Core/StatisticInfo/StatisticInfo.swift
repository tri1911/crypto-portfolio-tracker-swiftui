//
//  StatisticInfo.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-03.
//

import Foundation

class StatisticInfo: Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: String
    let changePercentage: Double?
    
    init(title: String, value: String, changePercentage: Double? = nil) {
        self.title = title
        self.value = value
        self.changePercentage = changePercentage
    }
}
