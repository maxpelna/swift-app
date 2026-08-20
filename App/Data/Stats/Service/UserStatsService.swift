//
//  UserStatsService.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation
import Observation

@Observable
final class UserStatsService: PUserStatsService {
    private(set) var isOnboardingFinished: Bool
    private(set) var appTheme: AppTheme

    @ObservationIgnored private let defaults: UserDefaults

    init(defaults: UserDefaults) {
        self.defaults = defaults
        isOnboardingFinished = defaults.bool(forKey: UserStatsKeys.isOnboardingFinished.rawValue)
        appTheme = AppTheme(rawValue: defaults.string(forKey: UserStatsKeys.appTheme.rawValue) ?? "") ?? .system
    }

    func setIsOnboardingFinished() {
        defaults.set(true, forKey: UserStatsKeys.isOnboardingFinished.rawValue)
        isOnboardingFinished = true
    }

    func setAppTheme(_ theme: AppTheme) {
        defaults.set(theme.rawValue, forKey: UserStatsKeys.appTheme.rawValue)
        appTheme = theme
    }

    func resetAll() {
        defaults.set(false, forKey: UserStatsKeys.isOnboardingFinished.rawValue)
        defaults.set(AppTheme.system.rawValue, forKey: UserStatsKeys.appTheme.rawValue)
        isOnboardingFinished = false
        appTheme = .system
    }
}
