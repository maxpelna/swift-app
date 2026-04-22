//
//  AppViewModel.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Combine
import Observation

@Observable
final class AppViewModel: UserStatsServiceInjectable, ConnectivityServiceInjectable, KeychainServiceInjectable {
    // MARK: - Event

    enum Event {
        case startApp
    }

    // MARK: - Private

    private var bag = Set<AnyCancellable>()

    // MARK: - State

    private(set) var appState: AppState = .loading
    private(set) var appTheme: AppTheme = .system
    private(set) var isConnected = true

    // MARK: - Task concern handlers

    @ObservationIgnored var currentTask: Task<Void, Never>?

    // MARK: - Init

    private let splashDurationInMilliseconds: Int

    init(splashDurationInMilliseconds: Int) {
        self.splashDurationInMilliseconds = splashDurationInMilliseconds
    }

    // MARK: - Handlers

    func addEvent(_ event: Event) {
        currentTask?.cancel()
        currentTask = Task {
            switch event {
            case .startApp:
                bag = .init()
                await startApp()
                listenStats()
                listenConnectivity()
            }
        }
    }

    private func startApp() async {
        potentiallyClearAllStorageAfterReinstall()

        // Just a dummy timer to show splash view. In real app there can be multiple checks
        // e.g. if token exists, if launched with deep link, if should show pin code.
        try? await Task.sleep(for: .milliseconds(splashDurationInMilliseconds))

        setOriginalStates()
    }

    private func listenStats() {
        userStatsService.reloadAppStatusTrigger
            .sink { [weak self] _ in self?.setOriginalStates() }
            .store(in: &bag)
    }

    private func listenConnectivity() {
        connectivityService.connectivityStatus
            .sink { [weak self] isConnected in
                if self?.isConnected == false {
                    self?.setOriginalStates()
                }
                self?.isConnected = isConnected
            }
            .store(in: &bag)
    }

    // MARK: - Helper functions

    private func setOriginalStates() {
        appState = userStatsService.getIsOnboardingFinished() ? .authorized : .clean
        appTheme = userStatsService.getAppTheme()
    }

    private func potentiallyClearAllStorageAfterReinstall() {
        if keychainService.isFirstInstall() {
            userStatsService.resetAll()
            keychainService.markInstalled()
        }
    }
}
