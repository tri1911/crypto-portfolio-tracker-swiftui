//
//  CoinImageService.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-02.
//

import Foundation
import Combine
import SwiftUI

class CoinImageService {
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?
    
    init(for coin: CoinInfo) {
        self.cachedImageName = coin.id
        guard let url = URL(string: coin.image) else { return }
        if let cachedImage = imageCachingManager.retrieveImage(name: cachedImageName, in: cachingImagesDirectory) {
            // print("Retrieved image for \(coin.name) from disk.")
            self.image = cachedImage
        } else {
            // print("Fetching image for \(coin.name).")
            fetchImage(url)
        }
    }
    
    private func fetchImage(_ url: URL) {
        cancellable = NetworkingManager.fetch(url)
            .map { UIImage(data: $0) }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] result in
                guard let self = self, let fetchedImage = result else { return }
                self.image = fetchedImage
                self.cancellable?.cancel()
                self.imageCachingManager.cacheImage(fetchedImage, name: self.cachedImageName, in: self.cachingImagesDirectory)
            }
    }
    
    // MARK: - Caching
    
    private let imageCachingManager = ImageCachingManager.shared
    private let cachingImagesDirectory = "CoinImagesCache"
    private let cachedImageName: String
}
