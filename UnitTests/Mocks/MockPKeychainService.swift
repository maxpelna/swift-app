//
//  MockPKeychainService.swift
//  swift-appTests
//
//  Created by Maksims Pelna on 21/02/2026.
//

@testable import swift_app

final class MockPKeychainService: PKeychainService {
    var firstInstallReturn = false
    var markInstalledCallCount = 0

    func isFirstInstall() -> Bool {
        firstInstallReturn
    }

    func markInstalled() {
        markInstalledCallCount += 1
    }
}
