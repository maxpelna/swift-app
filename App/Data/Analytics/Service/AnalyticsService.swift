//
//  AnalyticsService.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

// User events would be translated to 3rd party services in this class in real app.
final class AnalyticsService: PAnalyticsService {
    func log(_ event: AnalyticsEvent) {
        #if DEBUG || STAGING
        print("🤝🤝🤝 Received analytics event: \(event) 🤝🤝🤝")
        #endif
    }
}
