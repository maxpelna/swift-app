//
//  ErrorHandler.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation
import Observation

@Observable
final class ErrorHandler {

    private(set) var errorMessage: String? = nil

    func showErrorMessage(_ error: Error?) {
        guard let error else { return }

        errorMessage = localizeError(error)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.errorMessage = nil
        }
    }

    private func localizeError(_ error: Error) -> String? {
        switch error {
        case AppError.emptyState:
            return nil
        case APIError.invalidUrl:
            return String(localized: .errorInvalidUrl)
        case APIError.decoding:
            return String(localized: .errorDecode)
        case APIError.server(let statusCode, let description):
            if let description = description {
                return description
            } else {
                return String(localized: .errorServerStatus(statusCode))
            }
        case APIError.unknown(_):
            return String(localized: .errorDefault)
        default:
            return String(localized: .errorDefault)
        }
    }
}
