//
//  OnboardingViewModelTests.swift
//  swift-appTests
//
//  Created by Maksims Pelna on 21/02/2026.
//

import Testing
@testable import swift_app

@MainActor
@Suite(.serialized)
struct OnboardingViewModelTests {
    private func makeViewModel(stats: MockPUserStatsService) -> OnboardingViewModel {
        OnboardingViewModel(userStatsService: stats)
    }

    @Test
    func finishOnboarding_marksOnboardingFinished() {
        let stats = MockPUserStatsService()
        let vm = makeViewModel(stats: stats)

        #expect(!stats.isOnboardingFinished)

        vm.addEvent(.finishOnboarding)

        #expect(stats.isOnboardingFinished)
        #expect(stats.setOnboardingCallCount == 1)
    }
}
