//
//  AppTheme.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

enum AppTheme: String, Identifiable, CaseIterable {
    case system
    case dark
    case light

    var id: String { rawValue }
}
