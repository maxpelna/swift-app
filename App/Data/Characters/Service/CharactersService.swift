//
//  CharactersService.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

final class CharactersService: PCharactersService {

    let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func charactersResult(
        page: Int,
        name: String?,
        status: CharacterStatus?,
        gender: CharacterGender?
    ) async throws -> CharactersResult {
        try await apiClient.request(
            CharactersResultEndpoint(
                page: page,
                name: name,
                status: CharacterStatusParameter(from: status),
                gender: CharacterGenderParameter(from: gender)
            )
        ).toDomain()
    }
}
