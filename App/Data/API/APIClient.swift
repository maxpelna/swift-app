//
//  APIClient.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

final class APIClient {
    // MARK: - Retry policy

    private enum RetryPolicy {
        static let maxAttempts = 3
        static let baseDelay: Double = 1.0

        static func delay(for attempt: Int) -> Double {
            baseDelay * Double(attempt)
        }
    }

    // MARK: - Properties

    private let session: URLSession
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    // MARK: - Init

    init(session: URLSession = APIClient.makeDefaultSession()) {
        self.session = session
    }

    // MARK: - Type methods

    private static func makeDefaultSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        config.waitsForConnectivity = true
        config.urlCache = URLCache(memoryCapacity: 4_000_000, diskCapacity: 20_000_000)
        return URLSession(configuration: config)
    }

    // MARK: - Public methods

    func request<T: APIEndpoint>(_ endpoint: T) async throws -> T.Response {
        guard let url = endpoint.url else {
            throw APIError.invalidUrl
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue

        return try await requestWithRetry(urlRequest)
    }

    // MARK: - Private methods

    private func requestWithRetry<Response: Decodable>(_ urlRequest: URLRequest) async throws -> Response {
        var lastError: APIError = .unknown(URLError(.unknown))

        for attempt in 0..<RetryPolicy.maxAttempts {
            if attempt > 0 {
                let delay = RetryPolicy.delay(for: attempt)
                logRetry(attempt: attempt, delay: delay)
                try await Task.sleep(for: .seconds(delay))
            }

            do {
                return try await performRequest(urlRequest)
            } catch let apiError as APIError {
                guard apiError.isRetryable else { throw apiError }
                lastError = apiError
            }
        }

        throw lastError
    }

    private func performRequest<Response: Decodable>(_ urlRequest: URLRequest) async throws -> Response {
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
                logServerError(statusCode: httpResponse.statusCode, description: nil)
                throw APIError.server(statusCode: httpResponse.statusCode, description: nil)
            }

            logServerError(statusCode: httpResponse.statusCode, description: errorDescriptionFromAPI)
            throw APIError.server(statusCode: httpResponse.statusCode, description: errorDescriptionFromAPI)
        }

        do {
            return try decoder.decode(Response.self, from: data)
        } catch {
            logDecodingError(error)
            throw APIError.decoding
        }
    }
}
