//
//  PUserStatsService.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

protocol PUserStatsService {
    var isOnboardingFinished: Bool { get }
    var appTheme: AppTheme { get }

    func setIsOnboardingFinished()
    func setAppTheme(_ theme: AppTheme)
    func resetAll()
}
