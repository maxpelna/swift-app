//
//  CharacterGenderExtension.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

extension CharacterGender {
    func localized() -> String {
        switch self {
        case .male:
            return String(localized: .characterGenderMale)

        case .female:
            return String(localized: .characterGenderFemale)

        case .genderless:
            return String(localized: .characterGenderGenderless)

        case .unknown:
            return String(localized: .characterGenderUnknown)
        }
    }
}
