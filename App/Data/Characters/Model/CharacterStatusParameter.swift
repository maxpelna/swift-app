//
//  CharacterStatusParameter.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

enum CharacterStatusParameter: String, Codable {
    case alive
    case dead
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self = CharacterStatusParameter(rawValue: value) ?? .unknown
    }

    init?(from domain: CharacterStatus?) {
        guard let domain else { return nil }

        switch domain {
        case .alive:
            self = .alive

        case .dead:
            self = .dead

        case .unknown:
            self = .unknown
        }
    }

    func toDomain() -> CharacterStatus {
        switch self {
        case .alive:
            return .alive

        case .dead:
            return .dead

        case .unknown:
            return .unknown
        }
    }
}
