//
//  AppError.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

enum AppError: Error {
    case emptyState
    case noConnection
    /// Anything the presentation layer treats the same way. Carries the original so
    /// diagnostics keep the whole chain instead of a renamed category.
    case caught(Error)
}
