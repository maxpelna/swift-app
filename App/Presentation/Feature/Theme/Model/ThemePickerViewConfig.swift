//
//  ThemePickerConfig.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

struct ThemePickerViewConfig {
    let selectedTheme: AppTheme
    let onChangeTheme: (AppTheme) -> Void
}

extension ThemePickerViewConfig: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(selectedTheme)
    }
}

extension ThemePickerViewConfig: Equatable {
    static func == (lhs: ThemePickerViewConfig, rhs: ThemePickerViewConfig) -> Bool {
        return lhs.selectedTheme == rhs.selectedTheme
    }
}
