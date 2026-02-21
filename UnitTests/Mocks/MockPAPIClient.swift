//
//  MockPAPIClient.swift
//  swift-appTests
//
//  Created by Maksims Pelna on 21/02/2026.
//

import Foundation
@testable import swift_app

final class MockPAPIClient: PAPIClient {
    var stubbedError: Error?
    var stubbedResponse: Any?
    var callCount = 0
    var lastEndpointQueryItems: [URLQueryItem]?

    func request<T: APIEndpoint>(_ endpoint: T) async throws -> T.Response {
        callCount += 1
        lastEndpointQueryItems = endpoint.queryItems

        if let error = stubbedError { throw error }

        guard let response = stubbedResponse as? T.Response else {
            throw APIError.decoding
        }
        return response
    }
}
