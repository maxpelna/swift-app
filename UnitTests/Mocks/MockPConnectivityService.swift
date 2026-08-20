//
//  MockPConnectivityService.swift
//  swift-appTests
//

import Foundation
import Observation
@testable import swift_app

@Observable
final class MockPConnectivityService: PConnectivityService {
    var isConnected: Bool

    init(isConnected: Bool = true) {
        self.isConnected = isConnected
    }
}
