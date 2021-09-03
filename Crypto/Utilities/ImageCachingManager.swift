//
//  ImageCachingManager.swift
//  Crypto
//
//  Created by Elliot Ho on 2021-09-02.
//

import Foundation
import SwiftUI

class ImageCachingManager {
    static let shared = ImageCachingManager()
    private init() {}
    
    let fileManager = FileManager.default
    
    func cacheImage(_ image: UIImage, name: String, in directory: String) {
        guard let data = image.pngData(), let imageURL = getImageURL(for: name, in: directory) else { return }
        // save image data into file system
        do {
            try data.write(to: imageURL)
        } catch {
            print("Couldn't cache image named \(name). Error: \(error)")
        }
    }
    
    func retrieveImage(name: String, in directory: String) -> UIImage? {
        guard let imageURL = getImageURL(for: name, in: directory),
              let data = fileManager.contents(atPath: imageURL.path) else {
            return nil
        }
        return UIImage(data: data)
    }
    
    func getImageURL(for name: String, in directory: String) -> URL? {
        guard let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        // get directory url
        let directoryURL = cacheDir.appendingPathComponent(name)
        // create directory if it does not exist
        if !fileManager.fileExists(atPath: directoryURL.path) {
            do {
                try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Couldn't create directory \(directory). Error: \(error)")
            }
        }
        return directoryURL.appendingPathComponent(name + ".png")
    }
}
