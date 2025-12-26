//
//  EnvironmentValues.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import SwiftUI

private struct CoordinatorKey: EnvironmentKey {
    static let defaultValue = Coordinator()
}

extension EnvironmentValues {
    var coordinator: Coordinator {
        get { self[CoordinatorKey.self] }
        set { self[CoordinatorKey.self] = newValue }
    }
}

private struct ErrorHandlerKey: EnvironmentKey {
    static let defaultValue = ErrorHandler()
}

extension EnvironmentValues {
    var errorHandler: ErrorHandler {
        get { self[ErrorHandlerKey.self] }
        set { self[ErrorHandlerKey.self] = newValue }
    }
}

private struct AnalyticsLoggerKey: EnvironmentKey {
    static let defaultValue = AnalyticsLogger()
}

extension EnvironmentValues {
    var analyticsLogger: AnalyticsLogger {
        get { self[AnalyticsLoggerKey.self] }
        set { self[AnalyticsLoggerKey.self] = newValue }
    }
}
