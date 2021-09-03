//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-02.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var coins: [CoinInfo]?
    
    private let marketDataService = CoinMarketDataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Updates market data
        marketDataService.$coins
            .sink { [weak self] results in
                self?.coins = results
            }
            .store(in: &cancellables)
    }
}
