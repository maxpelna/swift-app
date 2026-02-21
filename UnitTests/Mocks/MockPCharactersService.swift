//
//  MockPCharactersService.swift
//  swift-appTests
//

import Foundation
@testable import swift_app

final class MockPCharactersService: PCharactersService {
    var callCount = 0
    var lastPage: Int?
    var lastName: String?
    var lastStatus: CharacterStatus?
    var lastGender: CharacterGender?

    var stubbedResult: CharactersResult = .init(
        characters: [],
        hasNextPage: false
    )
    var stubbedError: Error?

    func charactersResult(
        page: Int,
        name: String?,
        status: CharacterStatus?,
        gender: CharacterGender?
    ) async throws -> CharactersResult {
        callCount += 1
        lastPage = page
        lastName = name
        lastStatus = status
        lastGender = gender

        await Task.yield()

        if let error = stubbedError { throw error }
        return stubbedResult
    }
}
