//
//  AsyncImageSession.swift
//  swift-app
//
//  Created by Maksims Pelna on 21/09/2026.
//

import Foundation

enum AsyncImageSessions {
    static let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(
            memoryCapacity: 20 * 1_024 * 1_024,
            diskCapacity: 200 * 1_024 * 1_024
        )
        configuration.requestCachePolicy = .useProtocolCachePolicy

        return URLSession(configuration: configuration)
    }()
}
