//
//  AppThemeExtension.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import SwiftUI

extension AppTheme {
    var localizedTitle: String {
        switch self {
        case .light: return String(localized: .appThemeLight)
        case .system: return String(localized: .appThemeSystem)
        case .dark: return String(localized: .appThemeDark)
        }
    }
}

extension AppTheme {
    var image: Image {
        switch self {
        case .system: return Image(.themeLightPhone)
        case .dark: return Image(.themeDarkPhone)
        case .light: return Image(.themeLightPhone)
        }
    }
}
