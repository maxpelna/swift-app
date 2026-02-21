//
//  APILogger.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation
import OSLog

private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "swift-app", category: "APIClient")

extension APIClient {
    func log(_ data: Data?, _ response: URLResponse?) {
        #if DEBUG
        guard let data, let jsonAsString = String(data: data, encoding: .utf8) else { return }
        let url = response?.url?.absoluteString ?? ""
        logger.debug("⬇️ ⬇️ ⬇️\n Request: \(url)\nResponse: \(jsonAsString) \n⬆️ ⬆️ ⬆️")
        #endif
    }

    func logServerError(statusCode: Int, description: String?) {
        logger.error("API server error: HTTP \(statusCode)\(description.map { " — \($0)" } ?? "")")
    }

    func logDecodingError(_ error: any Error) {
        logger.error("API decoding error: \(error)")
    }
}
