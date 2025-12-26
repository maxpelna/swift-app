//
//  AppThemeChanger.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import SwiftUI

extension View {
    func triggerThemeChange(_ theme: AppTheme) {
        if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow {
            if theme == AppTheme.dark {
                window.overrideUserInterfaceStyle = .dark
            } else if theme == AppTheme.light {
                window.overrideUserInterfaceStyle = .light
            } else {
                window.overrideUserInterfaceStyle = .unspecified
            }
        }
    }
}
