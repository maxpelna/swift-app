//
//  MockPAnalyticsService.swift
//  swift-appTests
//
//  Created by Maksims Pelna on 21/02/2026.
//

@testable import swift_app

final class MockPAnalyticsService: PAnalyticsService {
    var callCount = 0
    var lastEvent: AnalyticsEvent?

    func log(_ event: AnalyticsEvent) {
        callCount += 1
        lastEvent = event
    }
}
