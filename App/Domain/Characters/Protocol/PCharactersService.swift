//
//  PCharactersService.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

protocol PCharactersService {
    func charactersResult(
        page: Int,
        name: String?,
        status: CharacterStatus?,
        gender: CharacterGender?
    ) async throws -> CharactersResult
}
