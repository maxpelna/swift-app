//
//  SettingsViewModel.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Observation

@Observable
final class SettingsViewModel: UserStatsServiceInjectable {
    // MARK: - State

    var selectedTheme: AppTheme {
        userStatsService.appTheme
    }

    // MARK: - Handlers

    func changeTheme(_ theme: AppTheme) {
        userStatsService.setAppTheme(theme)
    }

    func resetStats() {
        userStatsService.resetAll()
    }
}
