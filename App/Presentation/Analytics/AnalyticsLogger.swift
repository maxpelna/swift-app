//
//  AnalyticsLogger.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation
import Observation

@Observable
final class AnalyticsLogger: AnalyticsServiceInjectable {
    func log(_ event: AnalyticsEvent) {
        analyticsService.log(event)
    }
}
