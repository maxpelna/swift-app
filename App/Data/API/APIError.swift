//
//  APIError.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

enum APIError: Error {
    case invalidUrl
    case decoding
    case server(statusCode: Int, description: String?)
    case unknown(Error)
}

struct APIErrorData: Decodable {
    var error: String
}

extension APIError {
    func toAppError() -> AppError {
        switch self {
        case .invalidUrl:
            return .networkUnavailable

        case .decoding:
            return .decodingFailed

        case let .server(statusCode, description):
            // Normally, we don't map against text but against static codes in response objects,
            // provided by back-end documentation. In this example, I just catch empty state error
            // from response and map it to Domain layer error.
            if description?.lowercased() == "there is nothing here" {
                return .emptyState
            }
            return .serverError(statusCode: statusCode)

        case .unknown:
            return .networkUnavailable
        }
    }
}
