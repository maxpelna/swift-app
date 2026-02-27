//
//  AnalyticsEvent.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

struct AnalyticsEvent {
    let name: AnalyticsEventName
    let parameters: [String: String]?

    init(name: AnalyticsEventName, parameters: [String: String]? = nil) {
        self.name = name
        self.parameters = parameters
    }
}
