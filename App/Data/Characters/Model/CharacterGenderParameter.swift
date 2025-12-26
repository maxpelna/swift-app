//
//  CharacterGenderParameter.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

enum CharacterGenderParameter: String, Codable {
    case Female
    case Male
    case Genderless
    case Unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self).lowercased()
        self = CharacterGenderParameter(rawValue: value) ?? .Unknown
    }

    init?(from domain: CharacterGender?) {
        guard let domain else { return nil }

        switch domain {
        case .female:
            self = .Female
        case .male:
            self = .Male
        case .genderless:
            self = .Genderless
        case .unknown:
            self = .Unknown
        }
    }

    func toDomain() -> CharacterGender? {
        switch self {
        case .Female:
            return .female
        case .Male:
            return .male
        case .Genderless:
            return .genderless
        case .Unknown:
            return .unknown
        }
    }
}
