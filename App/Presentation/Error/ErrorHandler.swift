//
//  ErrorHandler.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation
import Observation

@Observable
final class ErrorHandler: ErrorReportingServiceInjectable {
    private(set) var errorMessage: String?

    @ObservationIgnored private var dismissTask: Task<Void, Never>?

    func showErrorMessage(_ error: Error?) {
        guard let error, !error.isCancellation else { return }
        guard let message = localizeError(error) else { return }

        errorMessage = message
        errorReportingService.recordNonFatalError(error)

        dismissTask?.cancel()
        dismissTask = Task {
            try? await Task.sleep(for: .seconds(Duration.toast))
            errorMessage = nil
        }
    }

    private func localizeError(_ error: Error) -> String? {
        switch error as? AppError {
        case .emptyState:
            return nil

        case .noConnection:
            return String(localized: .errorNetworkUnavailable)

        case .caught, .none:
            return String(localized: .errorDefault)
        }
    }
}
