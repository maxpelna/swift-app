//
//  ErrorExtension.swift
//  swift-app
//
//  Created by Maksims Pelna on 19/08/2026.
//

import Foundation

extension Error {
    var isCancellation: Bool {
        self is CancellationError
    }
}
