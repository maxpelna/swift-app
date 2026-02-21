//
//  CharacterResponse.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

struct CharacterResponse: Decodable {
    private enum CodingKeys: CodingKey {
        case id, name, status, gender, species, type, image, episode, created
    }

    let id: Int
    let name: String
    let status: CharacterStatusParameter?
    let gender: CharacterGenderParameter?
    let species: String
    let type: String
    let image: String
    let episode: [String]
    let created: Date

    nonisolated init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        status = try container.decodeIfPresent(CharacterStatusParameter.self, forKey: .status)
        gender = try container.decodeIfPresent(CharacterGenderParameter.self, forKey: .gender)
        species = try container.decode(String.self, forKey: .species)
        type = try container.decode(String.self, forKey: .type)
        image = try container.decode(String.self, forKey: .image)
        episode = try container.decode([String].self, forKey: .episode)
        created = try container.decode(Date.self, forKey: .created)
    }

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
