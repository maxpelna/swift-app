//
//  ErrorHandler.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation
import Observation

@MainActor
@Observable
final class ErrorHandler: ErrorReportingServiceInjectable {
    private(set) var errorMessage: String?

    @ObservationIgnored private var dismissTask: Task<Void, Never>?

    func showErrorMessage(_ error: Error?) {
        guard let error else { return }

        let message = localizeError(error)
        errorMessage = message

        if message != nil {
            errorReportingService.recordNonFatalError(error)
        }

        dismissTask?.cancel()
        dismissTask = Task {
            try? await Task.sleep(for: .seconds(3))
            errorMessage = nil
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
