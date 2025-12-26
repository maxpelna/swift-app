//
//  CharacterEntity.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

struct CharacterEntity: Identifiable {
    let id: Int
    let name: String
    let status: CharacterStatus?
    let gender: CharacterGender?
    let species: String
    let type: String
    let image: String
    let episode: [String]
    let created: Date
}
