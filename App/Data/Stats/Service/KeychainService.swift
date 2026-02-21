//
//  KeychainService.swift
//  swift-app
//
//  Created by Maksims Pelna on 21/02/2026.
//

import Foundation
import Security

// A lightweight Keychain sentinel used to detect clean app installs.
// Unlike UserDefaults, Keychain data persists across app uninstalls on iOS,
// so we can detect a genuine reinstall and clear stale UserDefaults data.
final class KeychainService: PKeychainService {
    private let account = "com.mpelna.swift-app.installSentinel"
    private let service = "com.mpelna.swift-app"

    func isFirstInstall() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecItemNotFound
    }

    func markInstalled() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: Data([1])
        ]
        SecItemAdd(query as CFDictionary, nil)
    }
}
