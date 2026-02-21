//
//  CharactersResultResponse.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

struct CharactersResultResponse: Decodable {
    private enum CodingKeys: CodingKey {
        case results, info
    }

    private let info: CharacterInfoResponse
    let results: [CharacterResponse]

    nonisolated init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        results = try container.decode([CharacterResponse].self, forKey: .results)
        info = try container.decode(CharacterInfoResponse.self, forKey: .info)
    }

    func toDomain() -> CharactersResult {
        return CharactersResult(
            characters: results.map { $0.toDomain() },
            hasNextPage: info.next != nil
        )
    }
}

private struct CharacterInfoResponse: Decodable {
    private enum CodingKeys: CodingKey {
        case next
    }

    let next: String?

    nonisolated init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        next = try container.decodeIfPresent(String.self, forKey: .next)
    }
}
