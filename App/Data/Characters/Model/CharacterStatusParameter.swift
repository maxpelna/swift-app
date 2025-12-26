//
//  CharacterStatusParameter.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

enum CharacterStatusParameter: String, Codable {
    case Alive
    case Dead
    case Unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self).lowercased()
        self = CharacterStatusParameter(rawValue: value) ?? .Unknown
    }

    init?(from domain: CharacterStatus?) {
        guard let domain else { return nil }

        switch domain {
        case .alive:
            self = .Alive
        case .dead:
            self = .Dead
        case .unknown:
            self = .Unknown
        }
    }

    func toDomain() -> CharacterStatus {
        switch self {
        case .Alive:
            return .alive
        case .Dead:
            return .dead
        case .Unknown:
            return .unknown
        }
    }
}
