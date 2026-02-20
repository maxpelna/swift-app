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
    private(set) var errorMessage: String?

    func showErrorMessage(_ error: Error?) {
        guard let error else { return }

        errorMessage = localizeError(error)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.errorMessage = nil
        }
    }

    private func localizeError(_ error: Error) -> String? {
        switch error {
        case AppError.emptyState, AppError.notFound:
            return nil

        case AppError.networkUnavailable:
            return String(localized: .errorNetworkUnavailable)

        case AppError.decodingFailed:
            return String(localized: .errorDecode)

        case AppError.serverError(let statusCode):
            return String(localized: .errorServerStatus(statusCode))

        default:
            return String(localized: .errorDefault)
        }
    }
}
