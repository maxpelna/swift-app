//
//  MockPErrorReportingService.swift
//  swift-appTests
//
//  Created by Maksims Pelna on 21/02/2026.
//

import Foundation
@testable import swift_app

final class MockPErrorReportingService: PErrorReportingService {
    var callCount = 0
    var lastError: Error?

    func recordNonFatalError(_ error: Error) {
        callCount += 1
        lastError = error
    }
}
