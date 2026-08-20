//
//  SettingsViewModelTests.swift
//  swift-appTests
//
//  Created by Maksims Pelna on 21/02/2026.
//

import Testing
@testable import swift_app

extension ViewModelTestsSuite {
    struct SettingsViewModelTests {
        private func makeViewModel(stats: MockPUserStatsService) -> SettingsViewModel {
            DIContainer.shared.userStatsService = stats
            return SettingsViewModel()
        }

        @Test
        func selectedTheme_followsService() {
            let stats = MockPUserStatsService()
            stats.appTheme = .dark
            let vm = makeViewModel(stats: stats)

            #expect(vm.selectedTheme == .dark)
        }

        @Test
        func selectedTheme_defaultsToSystemTheme() {
            let stats = MockPUserStatsService()
            let vm = makeViewModel(stats: stats)

            #expect(vm.selectedTheme == .system)
        }

        @Test
        func changeTheme_updatesSelectedThemeAndPersists() {
            let stats = MockPUserStatsService()
            let vm = makeViewModel(stats: stats)

            vm.changeTheme(.dark)

            #expect(vm.selectedTheme == .dark)
            #expect(stats.appTheme == .dark)
            #expect(stats.setThemeCallCount == 1)
        }

        @Test
        func changeTheme_calledMultipleTimes_keepsLastTheme() {
            let stats = MockPUserStatsService()
            let vm = makeViewModel(stats: stats)

            vm.changeTheme(.dark)
            vm.changeTheme(.light)

            #expect(vm.selectedTheme == .light)
            #expect(stats.appTheme == .light)
        }

        @Test
        func resetStats_callsServiceResetAll() {
            let stats = MockPUserStatsService()
            let vm = makeViewModel(stats: stats)

            vm.resetStats()

            #expect(stats.resetAllCallCount == 1)
        }
    }
}
