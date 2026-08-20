//
//  DelayedResult.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

enum DelayedResult<T> {
    case none
    case inProgress
    case success(T)
    case failure(Error)

    // MARK: - Values

    var value: T? {
        guard case let .success(value) = self else { return nil }

        return value
    }

    var error: Error? {
        guard case let .failure(error) = self else { return nil }

        return error
    }

    // MARK: - State

    var isNone: Bool {
        guard case .none = self else { return false }

        return true
    }

    var isInProgress: Bool {
        guard case .inProgress = self else { return false }

        return true
    }

    var isSuccessful: Bool {
        guard case .success = self else { return false }

        return true
    }

    var isError: Bool {
        guard case .failure = self else { return false }

        return true
    }
}
