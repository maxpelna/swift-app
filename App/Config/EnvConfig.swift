//
//  EnvConfig.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

enum EnvConfig {
    static let baseUrl: String = {
        guard let value = Bundle.main.infoDictionary?["BASE_URL"] as? String else {
            fatalError("BASE_URL missing from Info.plist — check .xcconfig assignment")
        }
        return value
    }()

    static let bundleId = Bundle.main.bundleIdentifier ?? "com.mpelna.swift-app"
}
