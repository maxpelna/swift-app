//
//  APIClient.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

protocol PAPIClient {
    func request<T: APIEndpoint>(_ endpoint: T) async throws -> T.Response
}

final class APIClient: PAPIClient {
    private let session: URLSession
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    init(session: URLSession = APIClient.makeDefaultSession()) {
        self.session = session
    }

    private static func makeDefaultSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        config.waitsForConnectivity = true
        config.urlCache = URLCache(memoryCapacity: 4_000_000, diskCapacity: 20_000_000)
        return URLSession(configuration: config)
    }

    func request<T: APIEndpoint>(_ endpoint: T) async throws -> T.Response {
        guard let url = endpoint.url else {
            throw APIError.invalidUrl
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: urlRequest)
            log(data, response)
        } catch {
            throw APIError.unknown(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown(NSError(domain: "Invalid response", code: 0))
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            var errorDescriptionFromAPI: String?

            do {
                let errorData = try decoder.decode(APIErrorData.self, from: data)

                errorDescriptionFromAPI = errorData.error
            } catch {
                throw APIError.server(statusCode: httpResponse.statusCode, description: nil)
            }

            throw APIError.server(statusCode: httpResponse.statusCode, description: errorDescriptionFromAPI)
        }

        do {
            let result = try decoder.decode(T.Response.self, from: data)

            return result
        } catch {
            throw APIError.decoding
        }
    }
}
