//
//  GlobalDataService.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-02.
//

import Foundation
import Combine

class GlobalDataService {
    @Published var result: GlobalData?
    private var cancellable: AnyCancellable?
    
    init() {
        fetchGlobalData()
    }
    
    func fetchGlobalData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        cancellable = NetworkingManager.fetch(url)
            .decode(type: GlobalDataResponse.self, decoder: JSONDecoder())
            .map { $0.data }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] result in
                self?.result = result
                self?.cancellable?.cancel()
            }
    }
}
