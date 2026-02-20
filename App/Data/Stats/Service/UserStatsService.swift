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

    func getIsOnboardingFinished() -> Bool {
        UserDefaults.standard.bool(forKey: UserStatsKeys.isOnboardingFinished.rawValue)
    }

    func setIsOnboardingFinished() {
        UserDefaults.standard.set(true, forKey: UserStatsKeys.isOnboardingFinished.rawValue)
        _reloadAppStatusTrigger.send(())
    }

    func getAppTheme() -> AppTheme {
        let raw = UserDefaults.standard.string(forKey: UserStatsKeys.appTheme.rawValue) ?? ""
        return AppTheme(rawValue: raw) ?? .system
    }

    func setAppTheme(_ theme: AppTheme) {
        UserDefaults.standard.set(theme.rawValue, forKey: UserStatsKeys.appTheme.rawValue)
    }

    func resetAll() {
        UserDefaults.standard.set(false, forKey: UserStatsKeys.isOnboardingFinished.rawValue)
        UserDefaults.standard.set(AppTheme.system.rawValue, forKey: UserStatsKeys.appTheme.rawValue)
        _reloadAppStatusTrigger.send(())
    }
}
