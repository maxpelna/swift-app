//
//  Routes.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

enum PageRoute: Hashable {
    case splash
    case onboarding
    case charactersList
    case settings
}

enum SheetRoute: Hashable, Identifiable {
    case charactersFilter(CharactersFilterViewConfig)
    case appThemePicker(ThemePickerViewConfig)

    var id: Self { self }
}
