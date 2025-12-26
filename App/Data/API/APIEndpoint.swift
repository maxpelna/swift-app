//
//  APIEndpoint.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

// MARK: - Abstract Interface

protocol APIEndpoint {
    associatedtype Response: Decodable

    var path: String { get }
    var method: APIMethod { get }
    var queryItems: [URLQueryItem]? { get }
}

extension APIEndpoint {
    var url: URL? {
        let baseUrl = EnvConfig.baseUrl

        guard let url = URL(string: baseUrl + path) else { return nil }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems

        return components?.url
    }
}

// MARK: - Implementation - available endpoints

struct CharactersResultEndpoint: APIEndpoint {
    typealias Response = CharactersResultResponse

    let path: String
    let method: APIMethod
    let queryItems: [URLQueryItem]?

    init(
        page: Int,
        name: String?,
        status: CharacterStatusParameter?,
        gender: CharacterGenderParameter?
    ) {
        var items = [URLQueryItem]()
        items.append(URLQueryItem(name: "page", value: "\(page)"))

        if let name {
            items.append(URLQueryItem(name: "name", value: name))
        }

        if let status {
            items.append(URLQueryItem(name: "status", value: status.rawValue))
        }

        if let gender {
            items.append(URLQueryItem(name: "gender", value: gender.rawValue))
        }

        self.path = "/character"
        self.method = .GET
        self.queryItems = items
    }
}
