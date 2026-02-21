//
//  SettingsViewModelTests.swift
//  swift-appTests
//
//  Created by Maksims Pelna on 21/02/2026.
//

import Testing
@testable import swift_app

@MainActor
@Suite(.serialized)
struct SettingsViewModelTests {
    private func makeViewModel(stats: MockPUserStatsService) -> SettingsViewModel {
        DIContainer.shared.userStatsService = stats
        return SettingsViewModel()
    }

    @Test
    func initialLoad_loadsThemeFromService() {
        let stats = MockPUserStatsService()
        stats.theme = .dark
        let vm = makeViewModel(stats: stats)

        vm.addEvent(.initialLoad)

        #expect(vm.selectedTheme == .dark)
    }

    @Test
    func initialLoad_defaultsToSystemTheme() {
        let stats = MockPUserStatsService()
        let vm = makeViewModel(stats: stats)

        vm.addEvent(.initialLoad)

        #expect(vm.selectedTheme == .system)
    }

    @Test
    func changeTheme_updatesSelectedThemeAndPersists() {
        let stats = MockPUserStatsService()
        let vm = makeViewModel(stats: stats)

        vm.addEvent(.changeTheme(.dark))

        #expect(vm.selectedTheme == .dark)
        #expect(stats.theme == .dark)
        #expect(stats.setThemeCallCount == 1)
    }

    @Test
    func changeTheme_calledMultipleTimes_keepsLastTheme() {
        let stats = MockPUserStatsService()
        let vm = makeViewModel(stats: stats)

        vm.addEvent(.changeTheme(.dark))
        vm.addEvent(.changeTheme(.light))

        #expect(vm.selectedTheme == .light)
        #expect(stats.theme == .light)
    }

    @Test
    func resetStats_callsServiceResetAll() {
        let stats = MockPUserStatsService()
        let vm = makeViewModel(stats: stats)

        vm.addEvent(.resetStats)

        #expect(stats.resetAllCallCount == 1)
    }
}
