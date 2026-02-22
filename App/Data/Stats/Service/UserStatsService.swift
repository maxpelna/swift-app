//
//  UserStatsService.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Combine
import Foundation

final class UserStatsService: PUserStatsService {
    var reloadAppStatusTrigger: AnyPublisher<Void, Never> { _reloadAppStatusTrigger.eraseToAnyPublisher() }

    private let _reloadAppStatusTrigger = PassthroughSubject<Void, Never>()
    private let defaults: UserDefaults

    init(defaults: UserDefaults) {
        self.defaults = defaults
    }

    func getIsOnboardingFinished() -> Bool {
        defaults.bool(forKey: UserStatsKeys.isOnboardingFinished.rawValue)
    }

    func setIsOnboardingFinished() {
        defaults.set(true, forKey: UserStatsKeys.isOnboardingFinished.rawValue)
        _reloadAppStatusTrigger.send(())
    }

    func getAppTheme() -> AppTheme {
        let raw = defaults.string(forKey: UserStatsKeys.appTheme.rawValue) ?? ""
        return AppTheme(rawValue: raw) ?? .system
    }

    func setAppTheme(_ theme: AppTheme) {
        defaults.set(theme.rawValue, forKey: UserStatsKeys.appTheme.rawValue)
    }

    func resetAll() {
        defaults.set(false, forKey: UserStatsKeys.isOnboardingFinished.rawValue)
        defaults.set(AppTheme.system.rawValue, forKey: UserStatsKeys.appTheme.rawValue)
        _reloadAppStatusTrigger.send(())
    }
}
