//
//  PUserStatsService.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Combine

protocol PUserStatsService {
    var reloadAppStatusTrigger: PassthroughSubject<Void, Never> { get }

    func getIsOnboardingFinished() -> Bool
    func setIsOnboardingFinished() -> Void
    func getAppTheme() -> AppTheme
    func setAppTheme(_ theme: AppTheme) -> Void
    func resetAll() -> Void
}
