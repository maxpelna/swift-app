//
//  APIClient.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

final class APIClient {
    func request<T: APIEndpoint>(_ endpoint: T) async throws -> T.Response {
        guard let url = endpoint.url else {
            throw APIError.invalidUrl
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: urlRequest)
            log(data, response)
        } catch {
            throw APIError.unknown(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown(NSError(domain: "Invalid response", code: 0))
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        guard (200..<300).contains(httpResponse.statusCode) else {
            var errorDescriptionFromAPI: String?

            do {
                let errorData = try decoder.decode(APIErrorData.self, from: data)

                errorDescriptionFromAPI = errorData.error
            } catch {
                throw APIError.server(statusCode: httpResponse.statusCode, description: nil)
            }

            // Normally, we don't map against text but against static codes in response objects,
            // provided by back-end documentation. In this example, I just catch empty state error
            // from response and map it to AppError so no toast is shown.
            // TODO: better option to use interceptor for such cases.
            if errorDescriptionFromAPI?.lowercased() == "there is nothing here" {
                throw AppError.emptyState
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
