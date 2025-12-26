//
//  DelayedResult.swift
//  swift-app
//
//  Created by Maksims Pelna on 26/12/2025.
//

import Foundation

struct DelayedResult<T> {

    let value: T?
    let error: Error?
    let isInProgress: Bool

    // MARK: - Initializers

    init(value: T?, error: Error?, isInProgress: Bool) {
        self.value = value
        self.error = error
        self.isInProgress = isInProgress
    }

    static func fromError(_ error: Error) -> DelayedResult {
        DelayedResult(value: nil, error: error, isInProgress: false)
    }

    static func fromValue(_ value: T) -> DelayedResult {
        DelayedResult(value: value, error: nil, isInProgress: false)
    }

    static func inProgress() -> DelayedResult {
        DelayedResult(value: nil, error: nil, isInProgress: true)
    }

    static func none() -> DelayedResult {
        DelayedResult(value: nil, error: nil, isInProgress: false)
    }

    static func fromNullable(_ value: T?) -> DelayedResult {
        value == nil ? .none() : .fromValue(value!)
    }

    static func success() -> DelayedResult<Void> {
        .fromValue(())
    }

    // MARK: - State Helpers

    var isSuccessful: Bool {
        value != nil
    }

    var isError: Bool {
        error != nil
    }

    var isNone: Bool {
        value == nil && error == nil && !isInProgress
    }
}
