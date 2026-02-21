//
//  PAPIClient.swift
//  swift-app
//
//  Created by Maksims Pelna on 21/02/2026.
//

import Foundation

protocol PAPIClient {
    func request<T: APIEndpoint>(_ endpoint: T) async throws -> T.Response
}
