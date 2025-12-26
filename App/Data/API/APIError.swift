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
