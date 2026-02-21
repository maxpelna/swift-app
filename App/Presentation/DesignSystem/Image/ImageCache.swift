//
//  ImageCache.swift
//  swift-app
//
//  Created by Maksims Pelna on 21/02/2026.
//

import UIKit

final class ImageCache: @unchecked Sendable {
    static let shared = ImageCache()

    private enum Constants {
        static let ttl: TimeInterval = 24 * 60 * 60
        static let countLimit = 200
        static let totalCostLimit = 50 * 1_024 * 1_024
        static let bytesPerPixel: CGFloat = 4
    }

    private let ttl: TimeInterval = Constants.ttl

    private let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = Constants.countLimit
        cache.totalCostLimit = Constants.totalCostLimit
        return cache
    }()

    private var timestamps: [NSString: Date] = [:]
    private let lock = NSLock()

    private init() {}

    func image(for url: URL) -> UIImage? {
        let key = url.absoluteString as NSString

        lock.lock()
        let storedAt = timestamps[key]
        lock.unlock()

        guard let storedAt, Date().timeIntervalSince(storedAt) < ttl else {
            removeImage(for: url)
            return nil
        }

        return cache.object(forKey: key)
    }

    func store(_ image: UIImage, for url: URL) {
        let key = url.absoluteString as NSString
        let cost = Int(image.size.width * image.size.height * image.scale * Constants.bytesPerPixel)
        cache.setObject(image, forKey: key, cost: cost)

        lock.lock()
        timestamps[key] = Date()
        lock.unlock()
    }

    func removeImage(for url: URL) {
        let key = url.absoluteString as NSString
        cache.removeObject(forKey: key)

        lock.lock()
        timestamps.removeValue(forKey: key)
        lock.unlock()
    }
}
