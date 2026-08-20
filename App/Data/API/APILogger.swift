//
//  APILogger.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation
import OSLog

nonisolated private let logger = Logger(subsystem: EnvConfig.bundleId, category: "APIClient")

nonisolated extension APIClient {
    func log(_ data: Data?, _ response: URLResponse?) {
        #if DEBUG || STAGING
        guard let data, let jsonAsString = String(data: data, encoding: .utf8) else { return }
        let url = response?.url?.absoluteString ?? ""
        logger.debug("⬇️ ⬇️ ⬇️\n Request: \(url)\nResponse: \(jsonAsString) \n⬆️ ⬆️ ⬆️")
        #endif
    }

    func logServerError(statusCode: Int, description: String?) {
        #if DEBUG || STAGING
        logger.error("API server error: HTTP \(statusCode)\(description.map { " — \($0)" } ?? "")")
        #endif
    }

    func logDecodingError(_ error: any Error) {
        #if DEBUG || STAGING
        logger.error("API decoding error: \(error)")
        #endif
    }

    func logRetry(attempt: Int, delay: Double) {
        #if DEBUG || STAGING
        logger.debug("🔄 Retry attempt \(attempt) after \(String(format: "%.2f", delay))s")
        #endif
    }
}
