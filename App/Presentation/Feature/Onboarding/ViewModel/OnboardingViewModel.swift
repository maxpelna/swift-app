//
//  OnboardingViewModel.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Observation

@Observable
final class OnboardingViewModel: UserStatsServiceInjectable {
    // MARK: - Handlers

    func finishOnboarding() {
        userStatsService.setIsOnboardingFinished()
    }
}
