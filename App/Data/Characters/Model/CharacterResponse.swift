//
//  CharacterResponse.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation


struct CharacterResponse: Decodable {
    let id: Int
    let name: String
    let status: CharacterStatusParameter?
    let gender: CharacterGenderParameter?
    let species: String
    let type: String
    let image: String
    let episode: [String]
    let created: Date

    func toDomain() -> CharacterEntity {
        return CharacterEntity(
            id: id,
            name: name,
            status: status?.toDomain(),
            gender: gender?.toDomain(),
            species: species,
            type: type,
            image: image,
            episode: episode,
            created: created
        )
    }
}
