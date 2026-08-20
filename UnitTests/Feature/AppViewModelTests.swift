//
//  AppViewModelTests.swift
//  swift-appTests
//
//  Created by Maksims Pelna on 21/02/2026.
//

import Testing
@testable import swift_app

extension ViewModelTestsSuite {
    struct AppViewModelTests {
        private func makeViewModel(
            stats: MockPUserStatsService,
            connectivity: MockPConnectivityService = MockPConnectivityService(),
            keychain: MockPKeychainService = MockPKeychainService()
        ) -> AppViewModel {
            DIContainer.shared.userStatsService = stats
            DIContainer.shared.connectivityService = connectivity
            DIContainer.shared.keychainService = keychain
            return AppViewModel(splashDurationInMilliseconds: 1)
        }

        // MARK: - appState

        @Test
        func appState_beforeSplashFinishes_isLoading() {
            let stats = MockPUserStatsService()
            stats.isOnboardingFinished = true
            let vm = makeViewModel(stats: stats)

            #expect(vm.appState == .loading)
        }

        @Test
        func appState_afterSplash_onboardingNotFinished_isClean() async {
            let stats = MockPUserStatsService()
            stats.isOnboardingFinished = false
            let vm = makeViewModel(stats: stats)

            await vm.startApp()

            #expect(vm.appState == .clean)
        }

        @Test
        func appState_afterSplash_onboardingFinished_isAuthorized() async {
            let stats = MockPUserStatsService()
            stats.isOnboardingFinished = true
            let vm = makeViewModel(stats: stats)

            await vm.startApp()

            #expect(vm.appState == .authorized)
        }

        @Test
        func appState_followsOnboardingFinishingLater() async {
            let stats = MockPUserStatsService()
            stats.isOnboardingFinished = false
            let vm = makeViewModel(stats: stats)

            await vm.startApp()
            #expect(vm.appState == .clean)

            stats.setIsOnboardingFinished()

            #expect(vm.appState == .authorized)
        }

        // MARK: - appTheme

        @Test
        func appTheme_followsService() {
            let stats = MockPUserStatsService()
            stats.appTheme = .dark
            let vm = makeViewModel(stats: stats)

            #expect(vm.appTheme == .dark)

            stats.setAppTheme(.light)

            #expect(vm.appTheme == .light)
        }

        // MARK: - isConnected

        @Test
        func isConnected_followsService() {
            let connectivity = MockPConnectivityService(isConnected: true)
            let vm = makeViewModel(stats: MockPUserStatsService(), connectivity: connectivity)

            #expect(vm.isConnected)

            connectivity.isConnected = false

            #expect(!vm.isConnected)
        }

        // MARK: - startApp

        @Test
        func startApp_firstInstall_resetsStorageAndMarksInstalled() async {
            let stats = MockPUserStatsService()
            let keychain = MockPKeychainService()
            keychain.firstInstallReturn = true
            let vm = makeViewModel(stats: stats, keychain: keychain)

            await vm.startApp()

            #expect(stats.resetAllCallCount == 1)
            #expect(keychain.markInstalledCallCount == 1)
        }

        @Test
        func startApp_returningUser_doesNotResetStorage() async {
            let stats = MockPUserStatsService()
            let keychain = MockPKeychainService()
            keychain.firstInstallReturn = false
            let vm = makeViewModel(stats: stats, keychain: keychain)

            await vm.startApp()

            #expect(stats.resetAllCallCount == 0)
            #expect(keychain.markInstalledCallCount == 0)
        }
    }
}
