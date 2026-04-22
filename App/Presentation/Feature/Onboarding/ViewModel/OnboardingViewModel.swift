//
//  OnboardingViewModel.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Observation

@Observable
final class OnboardingViewModel: UserStatsServiceInjectable {
    // MARK: - Event

    enum Event {
        case finishOnboarding
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
