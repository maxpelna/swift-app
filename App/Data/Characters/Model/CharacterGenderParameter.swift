//
//  CharacterGenderParameter.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

enum CharacterGenderParameter: String, Codable {
    case female
    case male
    case genderless
    case unknown

    nonisolated init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self = CharacterGenderParameter(rawValue: value) ?? .unknown
    }

    init?(from domain: CharacterGender?) {
        guard let domain else { return nil }

        switch domain {
        case .female:
            self = .female

        case .male:
            self = .male

        case .genderless:
            self = .genderless

        case .unknown:
            self = .unknown
        }
    }

    func toDomain() -> CharacterGender? {
        switch self {
        case .female:
            return .female

        case .male:
            return .male

        case .genderless:
            return .genderless

        case .unknown:
            return .unknown
        }
    }
}
