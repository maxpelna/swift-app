//
//  AppViewModelTests.swift
//  swift-appTests
//
//  Created by Maksims Pelna on 21/02/2026.
//

import Testing
@testable import swift_app

extension ViewModelTestsSuite {
    @MainActor
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

        @Test
        func initialState_isLoading() {
            let vm = makeViewModel(stats: MockPUserStatsService())
            #expect(vm.appState == .loading)
            #expect(vm.isConnected == true)
        }

        @Test
        func listenStats_onboardingNotFinished_setsCleanState() async {
            let stats = MockPUserStatsService()
            stats.isOnboardingFinished = false
            let vm = makeViewModel(stats: stats)

            vm.addEvent(.startApp)
            await vm.currentTask?.value

            stats.fireReload()

            #expect(vm.appState == .clean)
        }

        @Test
        func listenStats_onboardingFinished_setsAuthorizedState() async {
            let stats = MockPUserStatsService()
            stats.isOnboardingFinished = true
            let vm = makeViewModel(stats: stats)

            vm.addEvent(.startApp)
            await vm.currentTask?.value

            stats.fireReload()

            #expect(vm.appState == .authorized)
        }

        @Test
        func listenStats_setsAppThemeFromService() async {
            let stats = MockPUserStatsService()
            stats.theme = .dark
            let vm = makeViewModel(stats: stats)

            vm.addEvent(.startApp)
            await vm.currentTask?.value

            stats.fireReload()

            #expect(vm.appTheme == .dark)
        }

        @Test
        func listenConnectivity_reconnectTriggers() async {
            let stats = MockPUserStatsService()
            stats.isOnboardingFinished = true

            let connectivity = MockPConnectivityService(initialValue: true)
            let vm = makeViewModel(stats: stats, connectivity: connectivity)

            vm.addEvent(.startApp)
            await vm.currentTask?.value

            connectivity.send(false)
            #expect(vm.isConnected == false)

            connectivity.send(true)

            #expect(vm.appState == .authorized)
            #expect(vm.isConnected == true)
        }

        @Test
        func listenConnectivity_disconnect_updatesIsConnected() async {
            let stats = MockPUserStatsService()
            let connectivity = MockPConnectivityService(initialValue: true)
            let vm = makeViewModel(stats: stats, connectivity: connectivity)

            vm.addEvent(.startApp)
            await vm.currentTask?.value

            connectivity.send(false)

            #expect(vm.isConnected == false)
        }

        @Test
        func startApp_firstInstall_resetsStorageAndMarksInstalled() async {
            let stats = MockPUserStatsService()
            let keychain = MockPKeychainService()
            keychain.firstInstallReturn = true
            let vm = makeViewModel(stats: stats, keychain: keychain)

            vm.addEvent(.startApp)
            await vm.currentTask?.value

            #expect(stats.resetAllCallCount == 1)
            #expect(keychain.markInstalledCallCount == 1)
        }

        @Test
        func startApp_returningUser_doesNotResetStorage() async {
            let stats = MockPUserStatsService()
            let keychain = MockPKeychainService()
            keychain.firstInstallReturn = false
            let vm = makeViewModel(stats: stats, keychain: keychain)

            vm.addEvent(.startApp)
            await vm.currentTask?.value

            #expect(stats.resetAllCallCount == 0)
            #expect(keychain.markInstalledCallCount == 0)
        }

        @Test
        func startApp_setsAppStateAfterSplash() async {
            let stats = MockPUserStatsService()
            stats.isOnboardingFinished = true
            let vm = makeViewModel(stats: stats)

            vm.addEvent(.startApp)
            await vm.currentTask?.value

            #expect(vm.appState == .authorized)
        }
    }
}
