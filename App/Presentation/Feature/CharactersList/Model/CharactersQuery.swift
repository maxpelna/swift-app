//
//  CharactersQuery.swift
//  swift-app
//
//  Created by Maksims Pelna on 19/08/2026.
//

import Foundation

struct CharactersQuery: Equatable {
    var searchQuery: String = ""
    var gender: CharacterGender?
    var status: CharacterStatus?
}
