//
//  MockPUserStatsService.swift
//  swift-appTests
//
//  Created by Maksims Pelna on 21/02/2026.
//

import Foundation
import Observation
@testable import swift_app

@Observable
final class MockPUserStatsService: PUserStatsService {
    var isOnboardingFinished = false
    var appTheme: AppTheme = .system

    var setOnboardingCallCount = 0
    var setThemeCallCount = 0
    var resetAllCallCount = 0

    func setIsOnboardingFinished() {
        isOnboardingFinished = true
        setOnboardingCallCount += 1
    }

    func setAppTheme(_ theme: AppTheme) {
        appTheme = theme
        setThemeCallCount += 1
    }

    func resetAll() {
        isOnboardingFinished = false
        appTheme = .system
        resetAllCallCount += 1
    }
}
