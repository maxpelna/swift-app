//
//  CharactersServiceTests.swift
//  swift-appTests
//
//  Created by Maksims Pelna on 21/02/2026.
//

import Testing
import Foundation
@testable import swift_app

@MainActor
struct CharactersServiceTests {
    private func makeService(apiClient: MockPAPIClient) -> CharactersService {
        CharactersService(apiClient: apiClient)
    }

    @Test
    func charactersResult_success_returnsMappedDomainModel() async throws {
        let apiClient = MockPAPIClient()
        let response = try makeCharactersResultResponse(characters: [makeCharacterJSON()], hasNext: false)
        apiClient.stubbedResponse = response

        let service = makeService(apiClient: apiClient)
        let result = try await service.charactersResult(page: 1, name: nil, status: nil, gender: nil)

        #expect(result.characters.count == 1)
        #expect(result.characters[0].name == "Rick Sanchez")
        #expect(result.characters[0].status == .alive)
        #expect(result.characters[0].gender == .male)
        #expect(!result.hasNextPage)
    }

    @Test
    func charactersResult_withNextPage_hasNextPageTrue() async throws {
        let apiClient = MockPAPIClient()
        let response = try makeCharactersResultResponse(characters: [], hasNext: true)
        apiClient.stubbedResponse = response

        let service = makeService(apiClient: apiClient)
        let result = try await service.charactersResult(page: 1, name: nil, status: nil, gender: nil)

        #expect(result.hasNextPage)
    }

    @Test
    func charactersResult_networkError_throwsNetworkUnavailable() async {
        let apiClient = MockPAPIClient()
        apiClient.stubbedError = APIError.unknown(NSError(domain: "test", code: -1))

        let service = makeService(apiClient: apiClient)

        await #expect(throws: AppError.networkUnavailable) {
            try await service.charactersResult(page: 1, name: nil, status: nil, gender: nil)
        }
    }

    @Test
    func charactersResult_decodingError_throwsDecodingFailed() async {
        let apiClient = MockPAPIClient()
        apiClient.stubbedError = APIError.decoding

        let service = makeService(apiClient: apiClient)

        await #expect(throws: AppError.decodingFailed) {
            try await service.charactersResult(page: 1, name: nil, status: nil, gender: nil)
        }
    }

    @Test
    func charactersResult_emptyStateResponse_throwsEmptyState() async {
        let apiClient = MockPAPIClient()
        apiClient.stubbedError = APIError.server(statusCode: 404, description: "There is nothing here")

        let service = makeService(apiClient: apiClient)

        await #expect(throws: AppError.emptyState) {
            try await service.charactersResult(page: 1, name: nil, status: nil, gender: nil)
        }
    }

    @Test
    func charactersResult_serverError_throwsServerError() async {
        let apiClient = MockPAPIClient()
        apiClient.stubbedError = APIError.server(statusCode: 500, description: "Internal Server Error")

        let service = makeService(apiClient: apiClient)

        await #expect(throws: AppError.serverError(statusCode: 500)) {
            try await service.charactersResult(page: 1, name: nil, status: nil, gender: nil)
        }
    }

    @Test
    func charactersResult_buildsCorrectQueryItems() async throws {
        let apiClient = MockPAPIClient()
        let response = try makeCharactersResultResponse(characters: [], hasNext: false)
        apiClient.stubbedResponse = response

        let service = makeService(apiClient: apiClient)
        _ = try await service.charactersResult(page: 3, name: "Morty", status: .alive, gender: .female)

        let queryItems = apiClient.lastEndpointQueryItems ?? []
        let queryDict = Dictionary(uniqueKeysWithValues: queryItems.compactMap { item -> (String, String)? in
            guard let value = item.value else { return nil }
            return (item.name, value)
        })

        #expect(queryDict["page"] == "3")
        #expect(queryDict["name"] == "Morty")
        #expect(queryDict["status"] == "alive")
        #expect(queryDict["gender"] == "female")
    }

    @Test
    func charactersResult_omitsNilParameters() async throws {
        let apiClient = MockPAPIClient()
        let response = try makeCharactersResultResponse(characters: [], hasNext: false)
        apiClient.stubbedResponse = response

        let service = makeService(apiClient: apiClient)
        _ = try await service.charactersResult(page: 1, name: nil, status: nil, gender: nil)

        let queryItems = apiClient.lastEndpointQueryItems ?? []
        let names = queryItems.map(\.name)

        #expect(!names.contains("name"))
        #expect(!names.contains("status"))
        #expect(!names.contains("gender"))
    }
}

private func makeCharacterJSON(
    id: Int = 1,
    name: String = "Rick Sanchez",
    status: String = "alive",
    gender: String = "male"
) -> String {
    """
    {
      "id": \(id),
      "name": "\(name)",
      "status": "\(status)",
      "gender": "\(gender)",
      "species": "Human",
      "type": "",
      "image": "https://example.com/image.jpg",
      "episode": [],
      "created": "2017-11-04T18:48:46.250Z"
    }
    """
}

private func makeCharactersResultResponse(
    characters: [String],
    hasNext: Bool
) throws -> CharactersResultResponse {
    let resultsJSON = characters.joined(separator: ",")
    let nextJSON = hasNext ? "\"https://example.com/api/character?page=2\"" : "null"
    let json = """
    {
      "results": [\(resultsJSON)],
      "info": { "next": \(nextJSON) }
    }
    """
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return try decoder.decode(CharactersResultResponse.self, from: Data(json.utf8))
}
