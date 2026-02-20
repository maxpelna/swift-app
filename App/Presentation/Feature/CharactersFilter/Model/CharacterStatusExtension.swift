//
//  CharacterStatusExtension.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

extension CharacterStatus {
    func localized() -> String {
        switch self {
        case .alive:
            return String(localized: .characterStatusAlive)

        case .dead:
            return String(localized: .characterStatusDead)

        case .unknown:
            return String(localized: .characterStatusUnknown)
        }
    }
}
