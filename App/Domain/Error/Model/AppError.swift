//
//  AppError.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

enum AppError: Error, Equatable {
    case emptyState
    case networkUnavailable
    case serverError(statusCode: Int)
    case decodingFailed
    case unknown
}
