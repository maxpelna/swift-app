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
    case secret
}

enum SheetRoute: Hashable, Identifiable {
    case charactersFilter(CharactersFilterViewConfig)
    case appThemePicker(ThemePickerViewConfig)

    var id: Self { self }
}

enum DeepLink: Hashable {
    case secret

    init?(url: URL) {
        guard url.scheme == "mpelna", let host = url.host else { return nil }
        switch host {
        case "secret": self = .secret
        default: return nil
        }
    }
}
