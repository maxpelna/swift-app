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

    private(set) var selectedTheme: AppTheme = .system

    // MARK: - Event

    enum Event {
        case initialLoad
        case changeTheme(AppTheme)
        case resetStats
    }

    // MARK: - Handlers

    func addEvent(_ event: Event) {
        switch event {
        case .initialLoad: initialLoad()
        case .changeTheme(let theme): changeTheme(theme)
        case .resetStats: resetStats()
        }
    }

    private func initialLoad() {
        selectedTheme = userStatsService.getAppTheme()
    }

    private func changeTheme(_ theme: AppTheme) {
        selectedTheme = theme
        userStatsService.setAppTheme(theme)
    }

    private func resetStats() {
        userStatsService.resetAll()
    }
}
