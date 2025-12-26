//
//  CharactersResultResponse.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

struct CharactersResultResponse: Decodable {
    let results: [CharacterResponse]
    private let info: CharacterInfoResponse

    func toDomain() -> CharactersResult {
        return CharactersResult(
            characters: results.map { $0.toDomain() },
            hasNextPage: info.next != nil
        )
    }
}

private struct CharacterInfoResponse: Decodable {
    let next: String?
}
