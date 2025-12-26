//
//  AppTheme.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

enum AppTheme: String, Identifiable, CaseIterable {
    var id: String { rawValue }

    case system
    case dark
    case light
}
