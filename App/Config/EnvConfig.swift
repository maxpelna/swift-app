//
//  EnvConfig.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

enum EnvConfig {
    static let baseUrl: String = {
        Bundle.main.infoDictionary?["BASE_URL"] as? String ?? "https://example.com/api"
    }()
}
