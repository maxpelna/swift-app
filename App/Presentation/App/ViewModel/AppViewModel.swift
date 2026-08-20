//
//  AppViewModel.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Observation

@Observable
final class AppViewModel: UserStatsServiceInjectable, ConnectivityServiceInjectable, KeychainServiceInjectable {
    // MARK: - State

    private(set) var isSplashFinished = false

    var appState: AppState {
        guard isSplashFinished else { return .loading }

        return userStatsService.isOnboardingFinished ? .authorized : .clean
    }

    var appTheme: AppTheme {
        userStatsService.appTheme
    }

    var isConnected: Bool {
        connectivityService.isConnected
    }

    // MARK: - Init

    private let splashDurationInMilliseconds: Int

    init(splashDurationInMilliseconds: Int) {
        self.splashDurationInMilliseconds = splashDurationInMilliseconds
    }

    // MARK: - Handlers

    func startApp() async {
        potentiallyClearAllStorageAfterReinstall()

        // Just a dummy timer to show splash view. In real app there can be multiple checks
        // e.g. if token exists, if launched with deep link, if should show pin code.
        try? await Task.sleep(for: .milliseconds(splashDurationInMilliseconds))
        guard !Task.isCancelled else { return }

        isSplashFinished = true
    }

    private func potentiallyClearAllStorageAfterReinstall() {
        if keychainService.isFirstInstall() {
            userStatsService.resetAll()
            keychainService.markInstalled()
        }
    }
}
