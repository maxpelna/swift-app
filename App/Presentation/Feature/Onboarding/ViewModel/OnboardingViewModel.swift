//
//  OnboardingViewModel.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Observation

@MainActor
@Observable
final class OnboardingViewModel: UserStatsServiceInjectable {
    // MARK: - Event

    enum Event {
        case finishOnboarding
    }

    // MARK: - Dependencies

    let userStatsService: PUserStatsService

    // MARK: - Init

    init(userStatsService: PUserStatsService = DIContainer.shared.userStatsService) {
        self.userStatsService = userStatsService
    }

    // MARK: - Handlers

    func addEvent(_ event: Event) {
        switch event {
        case .finishOnboarding: finishOnboarding()
        }
    }

    private func finishOnboarding() {
        userStatsService.setIsOnboardingFinished()
    }
}
