//
//  ErrorReportingService.swift
//  swift-app
//
//  Created by Maksims Pelna on 21/02/2026.
//

import Foundation

final class ErrorReportingService: PErrorReportingService {
    func recordNonFatalError(_ error: Error) {
        // TODO: Forward to crash reporting provider
        // e.g. Crashlytics.crashlytics().record(error: error)
    }
}
