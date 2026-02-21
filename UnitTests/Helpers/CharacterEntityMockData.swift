//
//  CharacterEntityMockData.swift
//  swift-appTests
//
//  Created by Maksims Pelna on 21/02/2026.
//

import Foundation
@testable import swift_app

extension CharacterEntity {
    static func stub(
        id: Int = 1,
        name: String = "Rick Sanchez",
        status: CharacterStatus? = .alive,
        gender: CharacterGender? = .male,
        species: String = "Human",
        type: String = "",
        image: String = "https://example.com/image.jpg",
        episode: [String] = [],
        created: Date = Date(timeIntervalSince1970: 0)
    ) -> CharacterEntity {
        CharacterEntity(
            id: id,
            name: name,
            status: status,
            gender: gender,
            species: species,
            type: type,
            image: image,
            episode: episode,
            created: created
        )
    }
}
