//
//  MockPUserStatsService.swift
//  swift-appTests
//
//  Created by Maksims Pelna on 21/02/2026.
//

import Combine
@testable import swift_app

final class MockPUserStatsService: PUserStatsService {
    private let reloadSubject = PassthroughSubject<Void, Never>()
    var reloadAppStatusTrigger: AnyPublisher<Void, Never> { reloadSubject.eraseToAnyPublisher() }

    var isOnboardingFinished = false
    var theme: AppTheme = .system

    var setOnboardingCallCount = 0
    var setThemeCallCount = 0
    var resetAllCallCount = 0

    func getIsOnboardingFinished() -> Bool {
        return isOnboardingFinished
    }

    func setIsOnboardingFinished() {
        isOnboardingFinished = true
        setOnboardingCallCount += 1
    }

    func getAppTheme() -> AppTheme {
        return theme
    }

    func setAppTheme(_ theme: AppTheme) {
        self.theme = theme
        setThemeCallCount += 1
    }

    func resetAll() {
        resetAllCallCount += 1
    }

    func fireReload() {
        reloadSubject.send()
    }
}
