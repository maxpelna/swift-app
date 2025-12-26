//
//  UserStatsService.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Combine
import SwiftUI

final class UserStatsService: PUserStatsService {

    // To match latest technologies I am using SwiftUI's AppStorage property wrapper.
    // Usually SwiftUI should not be in Data module.
    @AppStorage(UserStatsKeys.isOnboardingFinished.rawValue)
    private var isOnboardingFinished: Bool = false

    @AppStorage(UserStatsKeys.appTheme.rawValue)
    private var theme: AppTheme = .system

    let reloadAppStatusTrigger = PassthroughSubject<Void, Never>()

    func getIsOnboardingFinished() -> Bool {
        isOnboardingFinished == true
    }
    
    func setIsOnboardingFinished() -> Void {
        isOnboardingFinished = true
        reloadAppStatusTrigger.send(())
    }

    func getAppTheme() -> AppTheme {
        return theme
    }

    func setAppTheme(_ theme: AppTheme) {
        self.theme = theme
    }

    func resetAll() -> Void {
        isOnboardingFinished = false
        theme = .system
        reloadAppStatusTrigger.send(())
    }
}
