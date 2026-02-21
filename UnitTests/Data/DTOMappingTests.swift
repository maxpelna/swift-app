//
//  DTOMappingTests.swift
//  swift-appTests
//
//  Created by Maksims Pelna on 21/02/2026.
//

import Testing
import Foundation
@testable import swift_app

@MainActor
struct DTOMappingTests {
    @Test
    func genderParameter_female_decodesCorrectly() throws {
        #expect(try decodeGender("female") == .female)
    }

    @Test
    func genderParameter_male_decodesCorrectly() throws {
        #expect(try decodeGender("male") == .male)
    }

    @Test
    func genderParameter_genderless_decodesCorrectly() throws {
        #expect(try decodeGender("genderless") == .genderless)
    }

    @Test
    func genderParameter_unknown_decodesCorrectly() throws {
        #expect(try decodeGender("unknown") == .unknown)
    }

    @Test
    func genderParameter_unrecognised_fallsBackToUnknown() throws {
        #expect(try decodeGender("alien") == .unknown)
    }

    @Test
    func genderParameter_toDomain_allCases() {
        #expect(CharacterGenderParameter.female.toDomain() == .female)
        #expect(CharacterGenderParameter.male.toDomain() == .male)
        #expect(CharacterGenderParameter.genderless.toDomain() == .genderless)
        #expect(CharacterGenderParameter.unknown.toDomain() == .unknown)
    }

    @Test
    func genderParameter_fromDomain_allCases() {
        #expect(CharacterGenderParameter(from: CharacterGender.female) == .female)
        #expect(CharacterGenderParameter(from: CharacterGender.male) == .male)
        #expect(CharacterGenderParameter(from: CharacterGender.genderless) == .genderless)
        #expect(CharacterGenderParameter(from: CharacterGender.unknown) == .unknown)
        #expect(CharacterGenderParameter(from: nil) == nil)
    }

    @Test
    func statusParameter_alive_decodesCorrectly() throws {
        #expect(try decodeStatus("alive") == .alive)
    }

    @Test
    func statusParameter_dead_decodesCorrectly() throws {
        #expect(try decodeStatus("dead") == .dead)
    }

    @Test
    func statusParameter_unknown_decodesCorrectly() throws {
        #expect(try decodeStatus("unknown") == .unknown)
    }

    @Test
    func statusParameter_unrecognised_fallsBackToUnknown() throws {
        #expect(try decodeStatus("zombie") == .unknown)
    }

    @Test
    func statusParameter_toDomain_allCases() {
        #expect(CharacterStatusParameter.alive.toDomain() == .alive)
        #expect(CharacterStatusParameter.dead.toDomain() == .dead)
        #expect(CharacterStatusParameter.unknown.toDomain() == .unknown)
    }

    @Test
    func statusParameter_fromDomain_allCases() {
        #expect(CharacterStatusParameter(from: CharacterStatus.alive) == .alive)
        #expect(CharacterStatusParameter(from: CharacterStatus.dead) == .dead)
        #expect(CharacterStatusParameter(from: CharacterStatus.unknown) == .unknown)
        #expect(CharacterStatusParameter(from: nil) == nil)
    }

    @Test
    func charactersResultResponse_toDomain_mapsCharactersAndNextPage() throws {
        let response = try decodeCharactersResultResponse(
            hasNext: true,
            characterCount: 2
        )
        let domain = response.toDomain()

        #expect(domain.characters.count == 2)
        #expect(domain.hasNextPage)
    }

    @Test
    func charactersResultResponse_toDomain_noNextPage() throws {
        let response = try decodeCharactersResultResponse(
            hasNext: false,
            characterCount: 0
        )
        let domain = response.toDomain()

        #expect(!domain.hasNextPage)
    }

    @Test
    func apiError_invalidUrl_mapsToNetworkUnavailable() {
        #expect(APIError.invalidUrl.toAppError() == .networkUnavailable)
    }

    @Test
    func apiError_decoding_mapsToDecodingFailed() {
        #expect(APIError.decoding.toAppError() == .decodingFailed)
    }

    @Test
    func apiError_unknown_mapsToNetworkUnavailable() {
        let error = APIError.unknown(NSError(domain: "test", code: -1))
        #expect(error.toAppError() == .networkUnavailable)
    }

    @Test
    func apiError_serverEmptyState_mapsToEmptyState() {
        let error = APIError.server(
            statusCode: 404,
            description: "There is nothing here"
        )
        #expect(error.toAppError() == .emptyState)
    }

    @Test
    func apiError_server500_mapsToServerError() {
        let error = APIError.server(statusCode: 500, description: nil)
        #expect(error.toAppError() == .serverError(statusCode: 500))
    }
}

private func decodeGender(_ value: String) throws -> CharacterGenderParameter {
    let json = "\"\(value)\""
    
    return try JSONDecoder().decode(CharacterGenderParameter.self, from: Data(json.utf8))
}

private func decodeStatus(_ value: String) throws -> CharacterStatusParameter {
    let json = "\"\(value)\""
    
    return try JSONDecoder().decode(CharacterStatusParameter.self, from: Data(json.utf8))
}

private func decodeCharactersResultResponse(hasNext: Bool, characterCount: Int) throws -> CharactersResultResponse {
    let characters = (1...max(1, characterCount)).prefix(
        characterCount
    ).map { id in
        """
        {
          "id": \(id),
          "name": "Character \(id)",
          "status": "Alive",
          "gender": "Male",
          "species": "Human",
          "type": "",
          "image": "https://example.com/\(id).jpg",
          "episode": [],
          "created": "2017-11-04T18:48:46.250Z"
        }
        """
    }
    .joined(separator: ",")

    let nextString = hasNext ? "\"https://example.com/api/character?page=2\"" : "null"
    let json = """
    {
      "results": [\(characters)],
      "info": { "next": \(nextString) }
    }
    """
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    
    return try decoder.decode(CharactersResultResponse.self, from: Data(json.utf8))
}
