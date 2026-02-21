//
//  ImageCache.swift
//  swift-app
//
//  Created by Maksims Pelna on 21/02/2026.
//

import UIKit

final class ImageCache: @unchecked Sendable {
    static let shared = ImageCache()

    private let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 200
        cache.totalCostLimit = 50 * 1_024 * 1_024
        return cache
    }()

    private init() {}

    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url.absoluteString as NSString)
    }

    func store(_ image: UIImage, for url: URL) {
        let cost = Int(image.size.width * image.size.height * image.scale * 4)
        cache.setObject(image, forKey: url.absoluteString as NSString, cost: cost)
    }
}
